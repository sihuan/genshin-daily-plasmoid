function sec2Day(sec) {
    let day = Math.floor(sec / 86400);
    let hour = Math.floor((sec - day * 86400) / 3600);
    let min = Math.floor((sec - day * 86400 - hour * 3600) / 60);
    // let rsec = Math.floor(sec - day * 86400 - hour * 3600 - min * 60);
    return `${ day ? `${day}天` : '' }${ hour ? `${hour}小时` : '' }${ min ? `${min}分钟` : '' }`;
}

//判断两个实际日期的差了几天 example: 2023-01-02 - 2022-12-31 = 2 = "后天"
function dDate(date1,date2){
    let date = new Date(date2.getYear() - date1.getYear(),date2.getMonth() - date1.getMonth(),date2.getDate() - date1.getDate());
    return date.getDate();
}

function maxTime(recovery_time) {
    let maxTime;
    if (recovery_time > 0) {
      maxTime = new Date().getTime() + recovery_time * 1000;
      let maxDate = new Date(maxTime);
      maxTime = `${maxDate.getHours()}:${maxDate.getMinutes()}`;

      switch (dDate(new Date(), maxDate)) {
        case 0:
            break;
        case 1:
            maxTime = `明天 ${maxTime}`;
            break;
        case 2:
            maxTime = `后天 ${maxTime}`;
            break;
      }
    } else {
      maxTime = "NOW!!!!";
    }

    return maxTime;
}