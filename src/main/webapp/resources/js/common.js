// Common.
var Common = {

	/**
	 * 공동으로 사용되는 Ajax 호출 함수
	 * 
	 * @param {_method}
	 *            GET, POST, PUT, DELETE
	 * @param {_url}
	 *            호출 url
	 * @param {_jsonObj}
	 *            보낼 데이터
	 * @param {_dataType}
	 *            응답받을 데이터 타입
	 * @param {_callback}
	 *            성공시 호출 할 함수
	 * @param {_errcallback}
	 *            오류시 호출 할 함수
	 * @param {_option}
	 *            옵션.
	 * @param {_header}
	 *            같이 보낼 헤더 값(함수형)
	 * 
	 */
	ajax : function(_method, _url, _jsonObj, _callback, _errcallback, _options, _header) {

		var _params = {};

		if (_method.toLowerCase() == 'get') {
			_params = _jsonObj;
		} else {
			_params = _jsonObj ? JSON.stringify(_jsonObj) : '';
		}

		var option = {
			async : true
		};

		option = $.extend(option, _options);

		$.ajax({
			type : _method,
			url : getContextPath() + _url,
			contentType : "application/json;charset=UTF-8",
			beforeSend : function(request) {
				if (_header) {
					_header(request);
				}
				
				// loading start....
				Common.showLoader();
			},
			crossDomain : true,
			dataType : "json",
			data : _params,
			async : option.async,
			success : function(data, textStatus, jqXHR) {
				if (_callback) {
					_callback(data, textStatus, jqXHR);
				}
			},
			complete : function(data) {
				// loading end....
				Common.removeLoader();
			},
			error : function(jqXHR, textStatus, errorThrown) {

				try {
					console.log("status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : "
							+ jqXHR.responseJSON.detailMessage);
				} catch (e) {
					console.log(e);
				}

				if (_errcallback) {
					_errcallback(jqXHR, textStatus, errorThrown);
				} else {
                    if(FormUtil.isNotEmpty(jqXHR.responseJSON)){
                        Common.setMsg("Fail : " + jqXHR.responseJSON.message);
                    }
				}
			}
		});
	},
	
	/**
	 * 파일 업로드 ajax
	 * @param _url
	 * @param _formData		: Common.getFormData(_sFormId);
	 * @param _callback
	 * @param _errcallback
	 * @param _options
	 */
	ajaxFile : function(_url, _formData, _callback, _errcallback, _options){ 
		$.ajax({
			url : getContextPath() + _url,
			processData : false,
			contentType : false,
			data : _formData,
			type : "POST",
			beforeSend : function(request) {
				// loading start....
				Common.showLoader();
			},
			success : function(data, textStatus, jqXHR) {
				
				if (_callback) {
					_callback(data, textStatus, jqXHR);
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				try {
					console.log("status : " + jqXHR.status);
					console.log("code : " + jqXHR.responseJSON.code);
					console.log("message : " + jqXHR.responseJSON.message);
					console.log("detailMessage : "
							+ jqXHR.responseJSON.detailMessage);
				} catch (e) {
					console.log(e);
				}

				if (_errcallback) {
					_errcallback(jqXHR, textStatus, errorThrown);
				} else {
					if(FormUtil.isNotEmpty(jqXHR.responseJSON)){
                        Common.setMsg("Fail : " + jqXHR.responseJSON.message);
					}
				}
			},
			complete : function() {
				// loading end....
				Common.removeLoader();
			}
		});
	},
	
	/**
	 * Form Id 에 속한 파일 type을 FormData 로 변경하여 리턴.
	 * @param _sFormId
	 * @returns {FormData}
	 */
	getFormData : function(_sFormId){
		var formData = new FormData();
		$.each($("#" + _sFormId + " > input[type=file]"), function(i, obj) {
			$.each(obj.files, function(j, file) {
				formData.append("file[" + i + j + "]", file);
			})
		});
		
		return formData;
	},

	/**
	 * 비동기 ajax 호출.
	 * @param _method
	 * @param _url
	 * @param _jsonObj
	 * @param _callback
	 * @param _errcallback
	 * @param _header
	 */
	ajaxSync : function(_method, _url, _jsonObj, _callback, _errcallback, _header) {
		Common.ajax(_method, _url, _jsonObj, _callback, _errcallback, {
			async : false
		}, _header);
	},
	
	getLoadingObj : function(){
		var contextPath = getContextPath();
		var loadingHtml = ''
			+ '<div id="_loading" class="prog">'
				+ '<p>'
				+ '<span><img src="' + contextPath + '/resources/images/common/logo_coway2.gif" alt="Coway" /></span>'
				+ '<span><img src="' + contextPath + '/resources/images/common/proge.gif" alt="loding...." /></span>'
				+ '</p>'
			+ '</div>';
		
		return $(loadingHtml);
	},
	
	/**
     * 화면 loading .... 표시.
     */
    showLoader : function(){
    	if(FormUtil.isNotEmpty($("#_loading").html())){
    		$("#_loading").show();
    	}else{
    		$("body").append(Common.getLoadingObj());
    	}
    },
    
    /**
     * 화면 loading .... 해제.
     */
    removeLoader : function(){
    	$("#_loading").hide();
    },

	/**
	 * Div - 팝업
	 * 
	 * @param _url
	 * @param _jsonObj
	 * @param _callback
	 * @param _isManualClose : 개발자가 수동으로 div 팝업창을 닫으려면 true
	 * @param _divId : 팝업 아이디 생성.
	 * @returns divObj
	 */
	popupDiv : function(_url, _jsonObj, _callback, _isManualClose, _divId) {

		var divId = "_popupDiv";

		if(FormUtil.isNotEmpty(_divId)){
			divId = _divId;
		}

		/*
		 * 팝업시 left/top 제외 시킴. => /webapp/WEB-INF/tiles/layout/default.jsp
		 *
		 */
		_jsonObj = $.extend(_jsonObj, {
			isPop : true,
			isDiv 	: true // div  팝업인 경우 본문만 삽입. : /etrust/src/main/webapp/WEB-INF/tiles/layout/emptyScript.jsp	
		});

       divId = generateDivId(divId);
	
        function generateDivId(divId){
            if ($("#" + divId).length > 0 ) {
                divId = "_popupDiv" + ($("#" + divId).length + 1);
                generateDivId(divId);
            }
            return divId;
		}

		var $obj = $('<div id="' + divId + '" name="_popupDiv"></div>');

		$('body').append($obj);

		$("#" + divId).attr("manualClose", _isManualClose);

		$.ajax({
			type : 'post',
			url : getContextPath() + _url,
			data : _jsonObj,
			dataType : "html",
			success : function(result, textStatus, XMLHttpRequest) {

				$obj.html(result);

				$obj.show();

				$obj.find('.btn_blue2').on('click', function() {
					if (_callback) {
						_callback(_jsonObj);
					}

					if($("#" + divId).attr("manualClose") != "true"){
						$obj.remove();						
					}
				});
				
				/* 팝업 드래그 start */
				$("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
				/* 팝업 드래그 end */

			},
			error : function() {
				Common.alert("Fail Common.popupDiv...");
			}
		});

		return $obj;
	},

	/**
	 * 새창 - 팝업
	 * 
	 * @param _formId
	 * @param _url
	 * @param _options
	 * @returns popObj
	 */
	popupWin : function(_formId, _url, _options) {

		var option = {
			winName : "popup",
			isDuplicate : true, // 계속 팝업을 띄울지 여부.
			fullscreen : "no", // 전체 창. (yes/no)(default : no)
			location : "no", // 주소창이 활성화. (yes/no)(default : yes)
			menubar : "no", // 메뉴바 visible. (yes/no)(default : yes)
			titlebar : "yes", // 타이틀바. (yes/no)(default : yes)
			toolbar : "no", // 툴바. (yes/no)(default : yes)
			resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
			scrollbars : "yes", // 스크롤바. (yes/no)(default : yes)
			width : "800px", // 창 가로 크기
			height : "500px" // 창 세로 크기
		};

		option = $.extend(option, _options);

		if (option.isDuplicate) {
			option.winName = option.winName + new Date();
		}

		var frm = document.getElementById(_formId);

		var popObj = window.open("", option.winName, "fullscreen="
				+ option.fullscreen + ",location=" + option.location
				+ ",menubar=" + option.menubar + ",titlebar=" + option.titlebar
				+ ",toolbar=" + option.toolbar + ",resizable="
				+ option.resizable + ",scrollbars=" + option.scrollbars
				+ ",width=" + option.width + ",height=" + option.height);

		/*
		 * 팝업시 left/top 제외 시킴. => /etrust/src/main/webapp/WEB-INF/tiles/view/header.jsp ==> class="solo" 
		 */
		var _input = document.createElement("textarea");
		_input.name = "isPop";
		_input.value = true;
		_input.style.display = 'none';

		frm.appendChild(_input);

		frm.action = getContextPath() + _url;
		frm.target = option.winName;
		frm.method = "post";
		frm.submit();

		return popObj;
	},

	/**
	 * 새창 - 팝업
	 * 
	 * @param _formId
	 * @param _url
	 * @param _options
	 * @returns popObj
	 */
	searchpopupWin : function(_formId, _url, gubun ,_options) {

		var option = {
			winName : "popup",
			isDuplicate : true, // 계속 팝업을 띄울지 여부.
			fullscreen : "no", // 전체 창. (yes/no)(default : no)
			location : "no", // 주소창이 활성화. (yes/no)(default : yes)
			menubar : "no", // 메뉴바 visible. (yes/no)(default : yes)
			titlebar : "yes", // 타이틀바. (yes/no)(default : yes)
			toolbar : "no", // 툴바. (yes/no)(default : yes)
			resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
			scrollbars : "yes", // 스크롤바. (yes/no)(default : yes)
			width : "800px", // 창 가로 크기
			height : "500px" // 창 세로 크기
		};

		option = $.extend(option, _options);

		if (option.isDuplicate) {
			option.winName = option.winName + new Date();
		}

		var frm = document.getElementById(_formId);

		var popObj = window.open("", option.winName, "fullscreen="
				+ option.fullscreen + ",location=" + option.location
				+ ",menubar=" + option.menubar + ",titlebar=" + option.titlebar
				+ ",toolbar=" + option.toolbar + ",resizable="
				+ option.resizable + ",scrollbars=" + option.scrollbars
				+ ",width=" + option.width + ",height=" + option.height);

		/*
		 * 팝업시 left/top 제외 시킴. => /etrust/src/main/webapp/WEB-INF/tiles/view/header.jsp ==> class="solo" 
		 */
		var _input = document.createElement("textarea");
		_input.name = "isPop";
		_input.value = true;
		_input.style.display = 'none';

		frm.appendChild(_input);
		
		var _input = document.createElement("textarea");
		_input.name = "isgubun";
		_input.value = gubun;
		_input.style.display = 'none';

		frm.appendChild(_input);

		frm.action = getContextPath() + _url;
		frm.target = option.winName;
		frm.method = "post";
		frm.submit();

		return popObj;
	},

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
    report : function(_formId, _options){

        var option = {
           isProcedure : false
        };

        option = $.extend(option, _options);

        var reportViewUrl = "/report/view.do"; // report를 보기 위한 uri

        if(option.isProcedure){
            reportViewUrl = "/report/view-proc.do"; // procedure로 구성된 report를 보기 위한 uri
		}

		if($("#viewType").val() == "WINDOW"){
            Common.popupWin(_formId, reportViewUrl, option);
		}else{
            $("#" + _formId).attr({
                action : getContextPath() + reportViewUrl,
                method : "POST"
            }).submit();
		}
    },
	
	openNew : function(url, data, target) {
		var form = document.createElement("form");
		form.action = getContextPath() + url;
		form.method = "post";
		form.target = target || "_self";
		if (data) {
			for ( var key in data) {
				var input = document.createElement("textarea");
				input.name = key;
				input.value = typeof data[key] === "object" ? JSON
						.stringify(data[key]) : data[key];
				form.appendChild(input);
			}
		}
		form.style.display = 'none';
		document.body.appendChild(form);
		form.submit();
	},
	
	/**
	 * 본문 하단 메세지 출력.
	 * @param message
	 */
	setMsg : function(message){
		try{
			$(".bottom_msg_box").html("<p>" + message + "</p>");
			$(".bottom_msg_box p").fadeOut(30000);
		}catch(e){
			Common.alert(message);
		}
	},
	
	/**
	 * alert 대체용.
	 * 예) Common.alert("message test~");
	 * @param message
	 */
	alert : function(message, callback) {
		var msgHtml = '<div id="popup_wrap" alert="Y" class="popup_wrap msg_box">'
				+ '	<header class="pop_header">' 
				+ '<h1>Message</h1>'
				+ '<p class="pop_close" id="_popClose"><a href="javascript:void(0);">close</a></p>'
				+ '</header>' 
				+ '<section class="pop_body">'
				+ '<p class="msg_txt">' + message + '</p>'
				+ '<ul class="center_btns">'
				+ '	<li><p class="btn_blue2" id="_alertOk"><a href="javascript:void(0);">OK</a></p></li>'
				+ '</ul>' 
				+ '</section>' 
				+ '</div>';

		var $obj = $(msgHtml);

		$("body").append($obj);
		
		$obj.find('#_popClose').on('click', function(){
			$obj.remove();
		});
		
		$obj.find('#_alertOk').on('click', function(){
			$obj.remove();
			
			if(callback){
				callback();
			}
		});
	},

	/**
	 * confirm 대체용.
	 * 예) Common.confirm("save ??", function(){...}, function{...});
	 * @param message
	 * @param okCallback
	 * @param cancelCallback
	 */
	confirm : function(message, okCallback, cancelCallback) {

		var msgHtml = '<div id="_popup_wrap_confirm"  confirm="Y" class="popup_wrap msg_box">'
				+ '	<header class="pop_header">' 
				+ '<h1>Message</h1>'
				+ '<p class="pop_close" id="_popClose"><a href="#">close</a></p>'
				+ '</header>' 
				+ '<section class="pop_body">'
				+ '<p class="msg_txt">' + message + '</p>'
				+ '<ul class="center_btns">'
				+ '	<li><p class="btn_blue2" id="_confirmOk"><a href="javascript:void(0);">OK</a></p></li>'
				+ '	<li><p class="btn_blue2" id="_confirmCancel"><a href="javascript:void(0);">Cancel</a></p></li>'
				+ '</ul>' 
				+ '</section>' 
				+ '</div>';

		var $obj = $(msgHtml);

		$("body").append($obj);
		
		$obj.find('#_popClose').on('click', function(){
			$obj.remove();
		});
		
		$obj.find('#_confirmOk').on('click', function(){
			if(okCallback){
				okCallback();	
			}
			
			$obj.remove();
		});
		
		$obj.find('#_confirmCancel').on('click', function(){
			if(cancelCallback){
				cancelCallback();				
			}
			$obj.remove();
		});
		
	    // Define the Dialog and its properties.
	    $("#_popup_wrap_confirm").dialog({
	        resizable: false,
	        modal: true,
	        title: "Modal",
	        height: 250,
	        width: 400
	    });
	},
	/**
	 * TO-DO check box등 필요시 등록 하세요~~
	 * 단일 data setting 대체용.
	 * 예) Common.setData(적용값 , 적용폼);
	 * @param message
	 * @param okCallback
	 * @param cancelCallback
	 */
	setData : function(result, form) {
		$.each(result, function(key, value) {			
			var $form = $(form).find("input, select, textarea");
			$.each($($form), function(index, elem) {
				if (key == $(this).attr("name")) {
					if ($(this).attr("type")) {
						$(this).val(value);
						console.log("text Box : " + key + ", value : " + value);
					} else {
						var name = elem.nodeName;
						if (name == "SELECT") {
							$(this).val(value);
							console.log("select box : " + key + ", value : " + value);
						} else if (name = "TEXTAREA") {
							console.log("Text area : " + key + ", value : " + value);
							$(this).val(value);
						}
					}
					return false;
				}
			});
		});
	}

};

/////////////////////////////////////
//  공통 combo
/////////////////////////////////////
var CommonCombo = {
        /**
         * 공통 콤보박스 : option 으로 처리.
         *
         * @param _comboId           : 콤보박스 id     String               => "comboId" or "#comboId"
         * @param _url                  : 호출 URL
         * @param _jsonParam        : 넘길 파라미터  json object      => {id : "im7015", name : "lim"}
         * @param _sSelectData      : 선택될 id        String              =>단건 : "aaa", 다건 :  "aaa|!|bbb|!|ccc"
         * @param _option              : 옵션.             소스내                => var option 참조.
         * @param _callback            : 콜백함수         function           => function(){..........}
         */
        make: function (_comboId, _url, _jsonParam, _sSelectData, _option, _callback) {

            Common.ajax("GET", _url, _jsonParam, function (data) {

                // default value....
                var option = {
                    id: "codeId",              // 콤보박스 value 에 지정할 필드명.
                    name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                    type: "S",                   // 'S' : 싱글, 'M' : 멀티.
                    chooseMessage: "",
                    width: '80%',              // width
                    isEnable: true,            // true : enable, false : disable
                    isCheckAll: true,          // true : checkAll, false : not check
                    isShowChoose: true  // Choose One 등 문구 보여줄지 여부.
                };

                option = $.extend(option, _option);

                if (option.type == "S") {
                    option.isCheckAll = false;
                }

                var targetObj = document.getElementById(_comboId);
                var custom = "";

                for (var i = targetObj.length - 1; i >= 0; i--) {
                    targetObj.remove(i);
                }

                var $_comboId = GridCommon.makeGridId(_comboId);

                if (option.type && option.type != "M") {
                    if (option.isShowChoose) {
                        if (FormUtil.isNotEmpty(option.chooseMessage)) {
                            custom = option.chooseMessage;
                        } else {
                            custom = (option.type == "S") ? eTrusttext.option.choose : ((option.type == "A") ? eTrusttext.option.all : "");
                        }

                        $("<option />", {value: "", text: custom}).appendTo($_comboId);
                    }

                } else {
                    $($_comboId).attr("multiple", "multiple");
                }

                var selectArray = [];

                if (FormUtil.isNotEmpty(_sSelectData)) {
                    selectArray = _sSelectData.split(DEFAULT_DELIMITER);
                }

                var dataObj = (data);

                $.each(data, function (index, value) {
                    console.log("selectArray.length(" + index + ") : " + selectArray.length + "   >    " + dataObj[index][option.id]);
                    if (selectArray.length > 0 && $.inArray(dataObj[index][option.id], selectArray) > 0) {
                        $('<option />', {
                            value: dataObj[index][option.id],
                            text: dataObj[index][option.name]
                        }).appendTo($_comboId).attr("selected", "true");
                    } else {
                        $('<option />', {
                            value: dataObj[index][option.id],
                            text: dataObj[index][option.name]
                        }).appendTo($_comboId);
                    }
                });

                if (option.type == "M") {
                    $($_comboId).multipleSelect({
                        selectAll: true,
                        width: option.width
                    });

                    if (option.isCheckAll) {
                        $($_comboId).multipleSelect("checkAll");
                    }

                    if (!option.isEnable) {
                        $($_comboId).multipleSelect("disable");
                    }
                }

                if (_callback) {
                    _callback(data);
                }

            }, function (jqXHR, textStatus, errorThrown) {
                Common.alert("Draw ComboBox['" + _comboId + "'] is failed. \n\n Please try again.");
            });

        },

    /**
	 * 아이디로 콤보 초기화
     * @param _comboId
     */
        initById: function (_comboId) {
            var targetObj = document.getElementById(_comboId);
            for (var i = targetObj.length - 1; i >= 0; i--) {
                targetObj.remove(i);
            }
        }
};

