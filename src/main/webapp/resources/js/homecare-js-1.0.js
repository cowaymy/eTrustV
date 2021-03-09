/********
 * HomeCare KR-JIN
 ******** */
(function($){
	$.fn.serializeObject = function() {
	      var result = {}
	      var extend = function(i, element) {
	        var node = result[element.name]
	        if ("undefined" !== typeof node && node !== null) {
	          if ($.isArray(node)) {
	            node.push(element.value)
	          } else {
	            result[element.name] = [node, element.value]
	          }
	        } else {
	          result[element.name] = element.value
	        }
	      }

	      $.each(this.serializeArray(), extend)
	      return result
	}
})(jQuery);

(function(window, document, $) {

	'use strict';

	var js = {

	};

	js.browser = {
            /**
             * 사용자의 브라우저 종류를 확인하여 리턴한다.<br>
             * @return {String} 브라우저 종류
             */
            getBrowserType:function() {
                var userAgent = navigator.userAgent.toLowerCase();

                if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (userAgent.indexOf("msie") != -1) ) {
                    return "msie";
                } else if (userAgent.indexOf("chrome") > -1) {
                    return "chrome";
                } else if (userAgent.indexOf("safari") > -1) {
                    return "safari";
                } else if (userAgent.indexOf("firefox") > -1) {
                    return "firefox";
                } else if (userAgent.indexOf("opera") > -1) {
                    return "opera";
                } else {
                    return "unknown";
                }
            },

            /**
             * 사용자의 브라우저가 MicroSoft Internet Explorer 인지 확인
             * @returns {Boolean}
             */
            isMsie:function() {
                return (this.getBrowserType() == "msie") ? true:false;
            },

            /**
             * 사용자의 브라우저가 Chrome 인지 확인
             * @returns {Boolean}
             */
            isChrome:function() {
                return (this.getBrowserType() == "chrome") ? true:false;
            },

            /**
             * 사용자의 브라우저가 Safari 인지 확인
             * @returns {Boolean}
             */
            isSafari:function() {
                return (this.getBrowserType() == "safari") ? true:false;
            },

            /**
             * 사용자의 브라우저가 Firefox 인지 확인
             * @returns {Boolean}
             */
            isFirefox:function() {
                return (this.getBrowserType() == "firefox") ? true:false;
            },

            /**
             * 사용자의 브라우저가 Opera 인지 확인
             * @returns {Boolean}
             */
            isOpera:function() {
                return (this.getBrowserType() == "opera") ? true:false;
            },

            /**
             * 사용자의 브라우저가 msie, chrome, safari, firefox, opera 중 하나가 아니면 true return
             * @returns {Boolean}
             */
            isUnknown:function() {
                return (this.getBrowserType() == "unknown") ? true:false;
            },

            isMobile:function() {

                var isMobile = false;

                if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) {
                    isMobile = true;
                }

                return isMobile;
	        }
    };


	/**
	 * validate
	 */
	js.validate = {
	    /**
	     * 시작일과 종료일을 비교.
	     * @param fromDate
	     * @param toDate
	     * @param msg
	     * @returns {Boolean}
	     */
        isDateValidPeriod : function(fromDate, toDate){
            if(fromDate == null || toDate == null){
                return true;
            }
            if(typeof fromDate != typeof toDate){
                return false;
            }
            if(fromDate > toDate){
                return false;
            }
            return true;
        },

        /**
         * form ~ to 날짜 공백 날짜 비교.
         * 두번째 날짜변수값만 입력한 경우 . true
         * @param fromDate
         * @param toDate
         * @returns
         */
	    isFromDateValid : function(oneDate, towDate){
	        return js.string.isEmpty(oneDate)&&js.string.isNotEmpty(towDate)?true:false;
	    }
	};

	js.String = {

        /**
         * String 일 경우 좌우측 여백 삭제
         * Array일 경우 빈 index 삭제 후 재할당
         * @param obj - 넘겨줄 값
         * @returns {Object}
         */
        trim:function(obj) {
            if(typeof obj === "string"){
                return obj.replace(/(^\s*)|(\s*$)/g, "");
            }
            else if(obj.constructor === Array) {
                var param = [];
                var j = 0;
                for(var i=0; i < obj.length; i++){
                    if(js.string.isNotEmpty(obj[i])){
                        param[j++] = obj[i];
                    }
                }
                return param;
            }
        },

        /**
         * 자열 str 가 null 이거나 "" 이면 defaultStr 그렇지 않다면 str을 반환한다.
         */
        defaultString:function(str, defaultStr){
            if(this.isEmpty(str))  return defaultStr;
            return str;
        },

        /**
         * 문자열 str 가 null 이거나 trim(str) 결과가 "" 와 같다면 true, 아니면 false 를 리턴한다.
         * @param str
         * @returns {Boolean}
         */
        isEmpty:function(str) {

            if (str == undefined || str == null || this.trim(str) == "") {
                return true;
            } else {
                return false;
            }
        },

        /**
         * 문자열 str 가 null 이거나 trim(str) 결과가 "" 와 다르다면 true, 아니면 false 를 리턴한다.
         * @param str
         * @returns {Boolean}
         */
        isNotEmpty:function(str) {
            return !this.isEmpty(str);
        },

        /**
         * 문자열 str 가 null, undefined 일때 ""값을 리턴한다.
         * @param str
         * @returns str
         */
        strNvl:function(str) {
            if (str == undefined || str == null || this.trim(str) == "") {
                return "";
            } else {
                return str;
            }
        },

        /**
         * 숫자형체크
         * @param str
         * @returns str
         */
        naNcheck:function(str){
        	return isNaN(str)?0:(Number(str)==Infinity||Number(str)==-Infinity)?0:Number(str);
        },

        /**
         * 문자열 인자의 구문을 분석해 특정 진수(수의 진법 체계에 기준이 되는 값)의 정수를 반환합니다.
         * roughScale('0xF', 16)) - 16진수 -> 10진수
         * @param x
         * @param base
         * @returns {Number}
         */
        roughScale:function(x, base) {
        	  var parsed = parseInt(x, base);
        	  if (isNaN(parsed)) { return 0 }
        	  return parsed;
        },

        /**
         * 10진수 -> x진수 변환
         * smoothScale("810001", 36)) -> 0HD01
         * @param x
         * @param base
         * @returns {Number}
         */
        smoothScale:function(x, base) {
        	var parsed = Number(x).toString(base);
      	    return parsed.toUpperCase();
        },

	    /**
	     * 문자를 받아서 3자리마다 콤마를 찍어 반환한다.
	     */
	    addcomma : function(arg){
	        var v = arg.toString();

	        var tmp=v.split('.');
	        var str=new Array();
	        var v=tmp[0].replace(/,/gi,''); //콤마를 빈문자열로 대체

	        for(var i=0;i<=v.length;i++){ //문자열만큼 루프를 돈다.

	            str[str.length]=v.charAt(v.length-i); //스트링에 거꾸로 담음

	            if(i%3==0&&i!=0&&i!=v.length){ //첫부분이나, 끝부분에는 콤마가 안들어감
	                str[str.length]='.'; //세자리마다 점을 찍음 - 배열을 핸들링할때 쉼표가 들어가면 헛갈리므로
	            }
	        }

	        str=str.reverse().join('').replace(/\./gi,','); //배열을 거꾸로된 스트링으로 바꾼후에, 점을 콤마로 치환

	        if(str.substring(0,1) == "-" && str.substring(1,2) == ","){
	            str = "-" + str.substring(2);
	        }

	        //return (tmp.length==2 && parseInt(tmp[1]) > 0)?str+'.'+tmp[1]:str;
	        return str;
	    },

	    /**
	     * 3자리 콤마를 지워서 반환한다.
	     */
	    deletecomma : function(str){
	        if((str.toString()).indexOf(",") < 0) return str;
	        if (str == '') str = "0";
	        return str.replace(/(.:)*[,]/gi,"");
	    },

        /**
         * 왼쪽 채움
         * lpad('1234', '0', 8);     // 00001234
         */
        lpad: function(s, c, n) {
            if (! s || ! c || s.length >= n) {
                return s;
            }

            var max = (n - s.length)/c.length;
            for (var i = 0; i < max; i++) {
                s = c + s;
            }

            return s;
        },

        /**
         * 오른쪽 채움
         * rpad('1234', '0', 8);     // 12340000
         */
        rpad: function(s, c, n) {
            if (! s || ! c || s.length >= n) {
                return s;
            }

            var max = (n - s.length)/c.length;
            for (var i = 0; i < max; i++) {
                s += c;
            }

            return s;
        }

	};

	js.date = {
		/**
		 * form ~ to 의 일수 차이를 알려준다.
		 * @param fromDate
         * @param toDate
         * @returns
		 */
		dateDiff:function(_date1, _date2) {
			var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
		    var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);

		    diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
		    diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());

		    var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
		    diff = Math.ceil(diff / (1000 * 3600 * 24));
		    return diff;
		},

		/**
		 * 해당 월의 일수 구하기
		 * @param year
         * @param month
         * @returns
		 */
		dayOfMonth:function(year, month){
			//month 는 0 부터 시작해서..
		    return 32 - new Date(year, month-1, 32).getDate();
		},

		/**
		*
		* @param startDate
		* @param endDate
		* @param field
		* @param validityOfMonth
		* @returns {Boolean}
		*/
		checkDateRange : function (startDate, endDate, field, validityOfMonth){

				var range = "";
		   var arrStDt = startDate.split('/');
		   var arrEnDt = endDate.split('/');
		   var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
		   var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

		   var diff = dat2 - dat1;
		   if(diff < 0){
		       Common.alert(field + " End Date MUST be greater than " + field + " Start Date.");
		       return false;
		   }

		   if (validityOfMonth == ""){
		   	Common.alert("Invalid Date Range Checking.");
		   } else if (validityOfMonth == "1"){
		   	range = 31;
		   } else if (validityOfMonth == "2"){
		   	range = 62;
		   } else if (validityOfMonth == "3"){
		   	range = 92;
		   } else if (validityOfMonth == "4"){
		   	range = 122;
		   } else if (validityOfMonth == "5"){
		   	range = 153;
		   } else if (validityOfMonth == "6"){
		   	range = 183;
		   }

		   if(js.date.dateDiff(dat1, dat2) > range){ // 3 months = 92
		       Common.alert("Please keep the " + field + " range within " + validityOfMonth + " months.");
		       return false;
		   }
		   return true;
		}


	};



	/**
	 * 바코드 출력을 위한 재생성 처리.
	 */
	js.print = {
		    /**
		     * 리포트 view  :  예제 파일 => sampleReport.jsp
		     *
		     * 1. _formId 내에 reportFileName, viewType 필수.
		     *
		     * reportFileName : /(업무폴더 포함)리포트 파일위치/파일명
		     * viewType : WINDOW, EXCEL, CSV, PDF
		     *
		     * 2. 프로시져로 구성된 리포트 파일 호출인 경우 _options.isProcedure = true  필수 .
		     *
		     * @param _formId
		     * @param _options
		     */
		    report: function (_formId, _options) {

		        var option = {
		            isProcedure: false,
		            isShowLoader : true,
		            isBodyLoad : false,
		            bodyId : "reportBody"
		        };

		        option = $.extend(option, _options);

		        var submitReportViewUrl = "/homecare/po/report/view-submit.do";
		        if (option.isProcedure) {
		            submitReportViewUrl = "/homecare/po/report/view-proc-submit.do";
		        }

		        var viewType = $("#viewType").val();

		        if (viewType == "WINDOW") {
		            if(option.isBodyLoad){
		                var frm = document.getElementById(_formId);
		                frm.action = getContextPath() + submitReportViewUrl;
		                frm.target = option.bodyId;
		                frm.method = "post";
		                frm.submit();
		            }else{
		                Common.popupWin(_formId, submitReportViewUrl, option);
		            }
		        } else if (viewType.match("^MAIL_")) {

		            var reportViewUrl = "/homecare/po/report/view.do"; // report를 보기 위한 uri

		            if (option.isProcedure) {
		                reportViewUrl = "/homecare/po/report/view-proc.do"; // procedure로 구성된 report를 보기 위한 uri
		            }

		            Common.ajax("POST", reportViewUrl, $("#" + _formId).serializeJSON(), function (data) {
		                Common.setMsg("<spring:message code='sys.msg.success'/>");
		            });
		        } else {
		            Common.showLoader();
		            $.fileDownload(getContextPath() + submitReportViewUrl, {
		                httpMethod: "POST",
		                data: $("#" + _formId).serialize(),
		            })
		                .done(function () {
		                    Common.removeLoader();
		                    console.log('File download a success!');
		                })
		                .fail(function () {
		                    Common.removeLoader();
		                    Common.alert('File download failed!');
		                });

		            // $("#" + _formId).attr({
		            //     action: getContextPath() + submitReportViewUrl,
		            //     method: "POST"
		            // }).submit();
		        }
		    }

	}

	window.js = js;
}(window, document, jQuery));
