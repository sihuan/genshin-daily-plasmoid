function sec2Day(sec,en = false) {
    let day = Math.floor(sec / 86400);
    let hour = Math.floor((sec - day * 86400) / 3600);
    let min = Math.floor((sec - day * 86400 - hour * 3600) / 60);
    // let rsec = Math.floor(sec - day * 86400 - hour * 3600 - min * 60);
    if (en) {
        return `${ day ? `${day}d ` : '' }${ hour ? `${hour}h ` : '' }${ min ? `${min}m ` : '' }`;
    }
    return `${ day ? `${day}天` : '' }${ hour ? `${hour}小时` : '' }${ min ? `${min}分钟` : '' }`;
}

//判断日期和今天差了几天 example: 2023-01-02 - 2022-12-31（今天） = 2 = "后天"
function dDate(date){
    let now = new Date();
    if(date.getFullYear() == now.getFullYear() && date.getMonth() == now.getMonth() && date.getDate() == now.getDate()){return 0}
    let ddate = new Date(date.getYear() - now.getYear(),date.getMonth() - now.getMonth(),date.getDate() - now.getDate());
    return ddate.getDate();
}

function sTime(timeStamp,en = false,today = false) {
    let date = new Date(timeStamp);
    let ddate = dDate(date);
    let time = `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
    switch (ddate) {
        case -1:
            time = `${en ? 'Yesterday' : '昨天'} ${time}`;
            break;
        case 0:
            if(today) {
                time = `${ en ? 'Today' : '今天' } ${time}`;
            }
            break;
        case 1:
            time = `${en ? "Tomorrow" : "明天"} ${time}`;
            break;
        case 2:
            time = `${en ? "After tomorrow" : "后天"} ${time}`;
            break;
        default:
            time = `${ddate}${en ? " days" : "天"}${en ? `${ ddate > 0 ? " later" : " ago" }` : `${ ddate > 0 ? "后" : "前"}` } ${time}`;
      }
    return time;
}


function maxTime(recovery_time,en = false,today = false) {
    let maxTime;
    if (recovery_time > 0) {
      maxTime = new Date().getTime() + recovery_time * 1000;
      let maxDate = new Date(maxTime);
      maxTime = sTime(maxDate,en,today);
    } else {
      maxTime = "NOW!!!!";
    }
    return maxTime;
}

function expeditionStatus(status,en = false){
    switch (status) {
        case "Ongoing":
            return en ? "Ongoing" : "派遣中";
        case "Finished":
            return en ? "Finished" : "派遣完成";
    }
}