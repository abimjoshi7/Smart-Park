const baseUrl = "http://api.anfa.demo-4u.net/api/"; //base url
const loginUrl = "${baseUrl}login/login"; // login url
const ticketUrl = "${baseUrl}checker/checker"; // checker url
const garbageUrl =
    "${baseUrl}garbageissue/garbageverify"; // garbage validation url
const garbageDepositUrl =
    "${baseUrl}garbageissue/savedeposit"; // garbage deposit url
const picnicDepositUrl = "${baseUrl}picnic/savedeposit"; // picnic deposit url
const getIssuedGarbageInfo =
    "${baseUrl}garbageissue/getissuedgarbageinfo"; // garbageissue url
const verifyGarbageUrl =
    "${baseUrl}garbageissue/verifygarbage"; // verifygarbage url
const picnicPrintUrl =
    "${baseUrl}picnic/printpicniccheckoutslip"; // print picnic url
const userUpdateUrl = "${baseUrl}login/editprofile"; // user update url

//bluetooth
// const bluetoothName = "BluetoothPrint";
// const bluetoothAddress = "66:11:22:33:44:55";
const bluetoothName = "InnerPrinter";
const bluetoothAddress = "00:11:22:33:44:55";
