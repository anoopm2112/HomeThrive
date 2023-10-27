import moment from "moment";

export function addDays(currentDate, days) {
    var dat = new Date(currentDate)
    dat.setDate(dat.getDate() + days);
    return dat;
}

export function getDates(startDate, stopDate) {
    const dateArray = new Array()
    let currentDate = new Date(startDate)
    const endDate = new Date(stopDate)
    while (currentDate <= endDate) {
        dateArray.push(moment(currentDate).format('YYYY-MM-DD'))
        currentDate = addDays(currentDate, 1)
    }
    return dateArray
}
