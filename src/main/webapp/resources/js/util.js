// Form 유틸.
var FormUtil = {

	/**
	 * 값이 없으면 0으로 바꾼다.
	 */
	nvl : function(obj) {
		if (obj.val().length == 0) {
			obj.val("0");
		}
	},

	/**
	 * 숫자만 입력.
	 */
	checkNum : function(obj) {
		var flag = false;
		if (isNaN(obj.val())) {
			obj.val("");
			obj.focus();
			flag = true;
		}
		return flag;
	},

	/**
	 * 전화 번호 형식으로 변경.
	 */
	toPhoneFormat : function(str) {
		var returnStr = "";
		if (str.length == 11) {
			returnStr = str.substring(0, 3) + "-" + str.substring(3, 7) + "-"
					+ str.substring(7);
		} else if (str.length == 10) {
			returnStr = str.substring(0, 3) + "-" + str.substring(3, 6) + "-"
					+ str.substring(6);
		} else {
			returnStr = str;
		}
		return returnStr;
	},

	/**
	 * 입력 값이 유효한 이메일 형식인지를 검사한다.
	 */
	checkEmail : function(val) {
		if (val.length > 0) {
			var regExp = /[a-z0-9_\.-]{2,}@[a-z0-9-]{2,}\.[a-z0-9]{2,}/i;

			if (!regExp.test(val)) {
				return true;
			}
		} else if (val == '') {
			return true;
		}

		return false;
	},

	checkMobile : function(val) {
		if (val.length > 0) {
			var regExp = /^01[016789]\d{3,4}\d{4}$/;

			if (!regExp.test(val)) {
				return true;
			}
		} else if (val == '') {
			return true;
		}

		return false;
	},

	/**
	 * 입력 값에 특수문자가 포함되어있는지를 검사한다.
	 */
	checkSpecialChar : function(val) {
		if (val.length > 0) {
			var regExp = /[~!@\#$%<>^&*\()\-=+_\’]/gi;

			if (!regExp.test(val)) {
				return true;
			}
		} else if (val == '') {
			return true;
		}

		return false;
	},

	isEmpty : function(str) {
		return typeof str == 'undefined' || str === null
				|| typeof str == 'string' && !str.trim();
	},
	
	isNotEmpty : function(str) {
		return !FormUtil.isEmpty(str);
	},

	/**
	 * 숫자와 . 만 입력가능. 소수점 두번째 자리까지 체크한다.
	 */
	checkPoint : function(val) {
		var flag = false;
		var regExp = /^[0-9.]*$/i;

		if (!regExp.test(val)) {
			alert("입력글자에 숫자와 점 이외에 다른값이 있습니다.");
			flag = true;
		} else if (5 < val.length) {
			alert("입력글자에 길이가 5보다 큽니다.");
			flag = true;
		} else {
			var temps = val.split(".");
			if (2 < temps.length) {
				alert("소수점이 한개 이상 존재 합니다.");
				flag = true;
			} else {
				if (2 < temps[1].length) {
					alert("소수점이하 둘째 이상 존재 합니다.");
					flag = true;
				}
			}
		}
		return flag;
	},

	// 한글 영문 바이트수
	byteLength : function(val) {
		var cnt = 0;
		for (var i = 0; i < val.length; i++) {
			var c = escape(val.charAt(i));

			if (c.length == 1) {
				cnt++;
			} else if (c.indexOf("%u") != -1) {
				cnt += 2;
			} else if (c.indexOf("%") != -1) {
				cnt += c.length / 3;
			}
		}
		return cnt;
	},

	/**
	 * 비밀 번호 연번 체크
	 * 
	 * @param val
	 */
	checkPassword : function(val) {
		for (var i = 0; i < val.length; i++) {
			if (val.charAt(i + 1) != "") {
				if (Math.abs(val.charAt(i) - val.charAt(i + 1)) < 2) {
					return true;
				}
			}
		}
		return false;
	},

	/**
	 * 사업자 번호 유효성 체크
	 */
	checkBizNum : function(bizID) {
		var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
		var i, Sum = 0, c2, remander;

		bizID = bizID.replace(/-/gi, '');

		for (i = 0; i <= 7; i++) {
			Sum += checkID[i] * bizID.charAt(i);
		}

		c2 = "0" + (checkID[8] * bizID.charAt(8));
		c2 = c2.substring(c2.length - 2, c2.length);

		Sum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));

		remander = (10 - (Sum % 10)) % 10;

		if (bizID.length != 10) {
			return true;
		} else if (Math.floor(bizID.charAt(9)) != remander) {
			return true;
		} else {
			return false;
		}
	},

	/**
	 * 필수값 체크
	 */
	checkReqValue : function(obj) {
		if (obj.val().trim().length == 0) {
			obj.focus();
			return true;
		}
		return false;
	},

	/**
	 * 전화번호 자리수 체크
	 */
	checkPhoneNumLength : function(val) {
		if (val.length == 11 || val.length == 10 || val.length == 9) {
			return false;
		}
		return true;
	},

	deleteLastChar : function(val, ch) {
		return val.substring(0, val.lastIndexOf(ch));
	},

	/**
	 * 날짜 형식에 맞게 변경.
	 * 
	 * @param date
	 *            현재 날짜(yyyyMMddhhmm형식)
	 * @param format
	 *            (yyyyMMdd, yyyyMMddhhmm, yyyyMMddHHmmss)
	 * @param splitStr
	 *            (ko 또는 split할 문자)
	 * @returns {String}
	 */
	convertStrToDateFormat : function(date, format, splitStr) {
		var rtnDate = '';
		if ("yyyyMMdd" == format) {
			if (date.length >= 8) {
				if ("" == splitStr) {
					rtnDate += date.substring(0, 4) + date.substring(4, 6)
							+ date.substring(6, 8);
				} else {
					if ("ko" == splitStr) {
						rtnDate += date.substring(0, 4) + "년 ";
						rtnDate += date.substring(4, 6) + "월 ";
						rtnDate += date.substring(6, 8) + "일";
					} else {
						rtnDate += date.substring(0, 4) + splitStr;
						rtnDate += date.substring(4, 6) + splitStr;
						rtnDate += date.substring(6, 8);
					}
				}
			} else {
				rtnDate = date;
			}
		} else if ("yyyyMMddHHmm" == format) {
			if (date.length >= 12) {
				if ("" == splitStr) {
					rtnDate += date.substring(0, 4) + date.substring(4, 6)
							+ date.substring(6, 8) + date.substring(8, 10)
							+ date.substring(10, 12);
				} else {
					if ("ko" == splitStr) {
						rtnDate += date.substring(0, 4) + "년 ";
						rtnDate += date.substring(4, 6) + "월 ";
						rtnDate += date.substring(6, 8) + "일 ";
						rtnDate += date.substring(8, 10) + "시 ";
						rtnDate += date.substring(10, 12) + "분 ";
					} else {
						alert(date);
						rtnDate += date.substring(0, 4) + splitStr;
						rtnDate += date.substring(4, 6) + splitStr;
						rtnDate += date.substring(6, 8) + " ";
						rtnDate += date.substring(8, 10) + ":";
						rtnDate += date.substring(10, 12);
					}
				}
			} else {
				rtnDate = date;
			}
		} else if ("yyyyMMddHHmmss" == format) {
			if (date.length >= 14) {
				if ("" == splitStr) {
					rtnDate += date.substring(0, 4) + date.substring(4, 6)
							+ date.substring(6, 8) + date.substring(8, 10)
							+ date.substring(10, 12) + date.substring(12, 14);
				} else {
					if ("ko" == splitStr) {
						rtnDate += date.substring(0, 4) + "년 ";
						rtnDate += date.substring(4, 6) + "월 ";
						rtnDate += date.substring(6, 8) + "일 ";
						rtnDate += date.substring(8, 10) + "시 ";
						rtnDate += date.substring(10, 12) + "분 ";
						rtnDate += date.substring(12, 14) + "초 ";
					} else {
						rtnDate += date.substring(0, 4) + splitStr;
						rtnDate += date.substring(4, 6) + splitStr;
						rtnDate += date.substring(6, 8) + " ";
						rtnDate += date.substring(8, 10) + ":";
						rtnDate += date.substring(10, 12) + ":";
						rtnDate += date.substring(12, 14);
					}
				}
			} else {
				rtnDate = date;
			}
		} else {
		}
		return rtnDate;
	},
	
	lpad : function (param, length, str) {
	    param = param + "";
	    return param.length >= length ? param : new Array(length - param.length + 1).join(str) + param;
	},
	
	IsValidBankAccount : function(IssueBankID, AccNo) {
        var valid = true;
        var LengthOfAccNo = AccNo.length;

        if (IssueBankID == 21 || IssueBankID == 30) {
            //MAYBANK
            if (LengthOfAccNo != 12)
                valid = false;
        }
        else if (IssueBankID == 3 || IssueBankID == 36) {
            //CIMB BANK
            if (LengthOfAccNo != 14 && LengthOfAccNo !=10)
                valid = false;
        }
        else if (IssueBankID == 6 || IssueBankID == 32) {
            //PUBLIC BANK
            if (LengthOfAccNo != 10)
                valid = false;
        }
        else if (IssueBankID == 7 || IssueBankID == 33) {
            //RHB BANK
            if (LengthOfAccNo != 14)
                valid = false;
        }
        else if (IssueBankID == 2 || IssueBankID == 35) {
            //ALLIANCE BANK
            if (LengthOfAccNo != 15)
                valid = false;
        }
        else if (IssueBankID == 5 || IssueBankID == 29) {
            //HONG LEONG BANK
            if (LengthOfAccNo != 11)
                valid = false;
        }
        else if (IssueBankID == 9 || IssueBankID == 26) {
            //BANK SIMPANAN NASIONAL
            if (LengthOfAccNo != 16)
                valid = false;
        }
        else if (IssueBankID == 25) {
            //MY CLEAR - BANK RAKYAT
            if (LengthOfAccNo != 12)
                valid = false;
        }
        else if (IssueBankID == 10) {
            //MY CLEAR - BANK ISLAM
            if (LengthOfAccNo != 14)
                valid = false;
        }
        else if (IssueBankID == 17) {
            //MY CLEAR - HSBC
            if (LengthOfAccNo != 12)
                valid = false;
        }
        else if (IssueBankID == 18) {
            //MY CLEAR - OCBC
            if (LengthOfAccNo != 10)
                valid = false;
        }
        else if (IssueBankID == 19 || IssueBankID == 34) {
            //MY CLEAR - STANDARD CHARTED
            if (LengthOfAccNo < 5 || LengthOfAccNo > 17)
                valid = false;
        }
        else if (IssueBankID == 16) {
            //MY CLEAR - CITIBANK
            if (LengthOfAccNo < 9 || LengthOfAccNo > 16)
                valid = false;
        }
        else if (IssueBankID == 27) {
            //MY CLEAR - DEUTCHE BANK
            if (LengthOfAccNo < 10 || LengthOfAccNo > 14)
                valid = false;
        }
        else if (IssueBankID == 13) {
            //MY CLEAR - BANK OF AMARICA
            if (LengthOfAccNo != 12)
                valid = false;
        }
        else if (IssueBankID == 45) {
            //MY CLEAR - J.P MORGAN
            if (LengthOfAccNo != 10)
                valid = false;
        }

        var IsRejectAcc = false;
        
        if(valid) {
            IsRejectAcc = FormUtil.IsRejectBankAccount(IssueBankID, AccNo);
            if (IsRejectAcc)
                valid = false;
        }

        return valid;
	},
	
	IsRejectBankAccount : function(IssueBankID, AccNo) {
        var isReject = false;
        if (IssueBankID == 21 || IssueBankID == 30) {
            //MAYBANK
            if(AccNo.substring(0, 1) == "4")
                isReject = true;
        }
        else if (IssueBankID == 3 || IssueBankID == 36) {
            //CIMB BANK
            if(AccNo.length == 14) {
                if(AccNo.substring(11, 12).trim() == "9" 
                || AccNo.substring(11, 12).trim() == "2"
                || AccNo.substring(11, 12).trim() == "1")
                    isReject = true;
            }
        }
        else if (IssueBankID == 6 || IssueBankID == 32) {
            //PUBLIC BANK
            if(AccNo.substring(0, 1) == "2" || AccNo.substring(0, 1) == "8")
                isReject = true;
        }
        else if (IssueBankID == 7 || IssueBankID == 33) {
            //RHB BANK
            if(AccNo.substring(0, 1) == "7")
                isReject = true;
        }
        else if (IssueBankID == 5 || IssueBankID == 29) {
            //HONG LEONG BANK
            if(AccNo.substring(3, 4).trim() == "8" || AccNo.substring(3, 4).trim() == "9")
                isReject = true;
        }

        return isReject;
	},
	
	onlyNumber : function (event){
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
            if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9  || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 110 || keyID == 190){ 
                return;
        }else{
                return false;
        }
    }
};
