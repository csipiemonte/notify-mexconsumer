var commons = require("../../commons/src/commons");
console.log(JSON.stringify(process.env, null, 4));
const conf = commons.merge(require('./conf/mexconsumer'), require('./conf/mexconsumer-' + (process.env.ENVIRONMENT || 'localhost')));
console.log(JSON.stringify(conf, null, 4));
const obj = commons.obj(conf);

const logger = obj.logger();
const eh = obj.event_handler();
const utility = obj.utility();
const queryBuilder = obj.query_builder();
const db = obj.db();
const crypto = obj.cryptoAES_cbc();
const encrypt = function (text) {
    if (!text || text === null) return null;
    return crypto.encrypt(text, conf.security.passphrase)
};

/**
 * check if payload message is in a correct format
 */
function checkMex(mex) {

    var res = [];

    if (!mex) {
        res.push("payload not present");
        return res;
    }
    if (typeof mex !== 'object' || Array.isArray(mex)) {
        res.push("payload element is not a valid object");
        return res;
    }

    if (!mex.id) res.push("id field is mandatory");
    if (!mex.user_id) res.push("user_id is mandatory");
    if (!mex.mex) res.push("mex is mandatory");
    if (!utility.checkNested(mex, "mex.title")) res.push("mex.title is mandatory");
    if (!utility.checkNested(mex, "mex.body")) res.push("mex.body is mandatory");

    return res;

}

async function sendMex(body) {

    var message = {
        id : body.payload.id,
        bulk_id : body.payload.bulk_id,
        user_id : body.payload.user_id,
        tag : body.payload.tag,
        correlation_id : body.payload.correlation_id
    };

    eh.info("trying to save mex", JSON.stringify({
        message: message
    }));
    logger.debug("trying to save mex");

    var mex = body.payload;

    mex.timestamp = utility.getDateFormatted(new Date(body.timestamp));
    //mex.timestamp = utility.getDateFormatted(new Date()); per test

    let user_id = mex.user_id.match(/^[a-fA-F0-9]{32}$/g)? mex.user_id:utility.hashMD5(mex.user_id);

    mex.email = mex.email ? mex.email : {};
    mex.push = mex.push ? mex.push : {};
    mex.sms = mex.sms ? mex.sms : {};
    mex.mex = mex.mex ? mex.mex : {};
    mex.io = mex.io ? mex.io : {};
    var insertSql = queryBuilder.insert().table("messages").values(
        {
            id: mex.id,
            bulk_id: mex.bulk_id,
            user_id: user_id,
            email_to: mex.email.to,
            email_subject: encrypt(mex.email.subject),
            email_body: encrypt(mex.email.body),
            email_template_id: mex.email.template_id,
            sms_phone: mex.sms.phone,
            sms_content: encrypt(mex.sms.content),
            push_token: mex.push.token,
            push_title: encrypt(mex.push.title),
            push_body: encrypt(mex.push.body),
            push_call_to_action: mex.push.call_to_action,
            mex_title: encrypt(mex.mex.title),
            mex_body: encrypt(mex.mex.body),
            mex_call_to_action: mex.mex.call_to_action,
            io: encrypt(JSON.stringify(mex.io)),
            client_token: encrypt(JSON.stringify(body.user)),
            sender: body.user.preference_service_name ? body.user.preference_service_name : body.user.client_name,
            tag: mex.tag? mex.tag.split(",").map(e => e.trim()) : mex.tag,
            correlation_id: mex.correlation_id,
            timestamp: mex.timestamp,
            memo: JSON.stringify(mex.memo)
        }
    ).sql;

    await db.execute(insertSql);

    eh.ok("mex saved", JSON.stringify({
        sender: body.user.preference_service_name ? body.user.preference_service_name : body.user.client_name,
        message: message
    }));
    logger.debug("mex saved");
}

logger.debug(JSON.stringify(process.env, null, 4));
logger.debug(JSON.stringify(conf, null, 4));
obj.consumer("mex", checkMex, null, sendMex, true)();

function sleep(ms){
    return new Promise(resolve=>{
        setTimeout(resolve,ms)
    })
}

async function shutdown(){
    try{
        await sleep(2000);
        logger.debug("STOPPING DATABASE");
        await db.end();
        logger.debug("STOPPED DATABASE");
    }catch(e){
        logger.error("error closing connection: ", e.message);
        process.exit(1);
    }
}

process.on("SIGINT",shutdown);
process.on("SIGTERM",shutdown);
