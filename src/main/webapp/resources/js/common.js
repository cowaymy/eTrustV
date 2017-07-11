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
			url : _url,
			contentType : "application/json;charset=UTF-8",
			beforeSend : function(request) {
				if (_header) {
					_header(request);
				}
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
					alert("Fail : " + jqXHR.responseJSON.message);
				}
			}
		});
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

	/**
	 * Div - 팝업
	 * 
	 * @param _url
	 * @param _jsonObj
	 * @param _callback
	 * @returns divObj
	 */
	popupDiv : function(_url, _jsonObj, _callback) {

		/*
		 * 팝업시 left/top 제외 시킴. => /webapp/WEB-INF/tiles/layout/default.jsp
		 */
		_jsonObj = $.extend(_jsonObj, {
			isPop : true
		});

		// TODO : div 팝업 class 적용 필요.
		var $obj = $('<div></div>');

		$('body').append($obj);

		$.ajax({
			type : 'post',
			url : _url,
			data : _jsonObj,
			dataType : "html",
			success : function(result, textStatus, XMLHttpRequest) {

				$obj.html(result);

				$obj.show();

				// TODO : close 버튼에 이벤트 추가 해야 함.
				$obj.find('.close').on('click', function() {
					if (_callback) {
						_callback(_jsonObj);
					}

					// TODO : 창 닫기.
				});

			},
			error : function() {
				alert("Fail Common.popupDiv...");
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
		 * 팝업시 left/top 제외 시킴. => /webapp/WEB-INF/tiles/layout/default.jsp
		 */
		var _input = document.createElement("textarea");
		_input.name = "isPop";
		_input.value = true;
		_input.style.display = 'none';

		frm.appendChild(_input);

		frm.action = _url;
		frm.target = option.winName;
		frm.method = "post";
		frm.submit();

		return popObj;
	},

	openNew : function(url, data, target) {
		var form = document.createElement("form");
		form.action = url;
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
	}

};

// publish code

$(document).ready(function(){
	/* 제이쿼리 ui달력 start*/
	var pickerOpts={
		changeMonth:true,
		changeYear:true,
	/*	dayNamesMin:["일","월","화","수","목","금","토"],
		monthNames:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
		monthNamesShort:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],*/
		dateFormat: "dd/mm/yy"
	};
	
	//if(jQuery.isEmptyObject( $(".j_date"))){
		$(".j_date").datepicker(pickerOpts);		
	//}

	var pickerOpts2={
		changeMonth:true,
		changeYear:true,
		showButtonPanel:true,
	/*	monthNames:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
		monthNamesShort:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],*/
		dateFormat: "mm/yy",
		onClose:function(dateText,inst){
			var month=$("#ui-datepicker-div .ui-datepicker-month :selected").val();
			var year=$("#ui-datepicker-div .ui-datepicker-year :selected").val();
			$(this).datepicker('setDate',new Date(year,month,1));
		}
	};
	
	//if(jQuery.isEmptyObject( $(".j_date2"))){
		$(".j_date2").datepicker(pickerOpts2);
		$(".j_date2").click(function(){
			$("#ui-datepicker-div").addClass("type2");
		});	
	//}
	
	/* 제이쿼리 ui달력 end*/

	/* on클래스 넣기 start*/
	$(document).on(
		"click", ".click_add_on", function(){

		var thisNum=$(".click_add_on").index(this);
		var thisAddOn=$(".click_add_on").eq(thisNum);

		thisAddOn.toggleClass("on");
		return false;
	});
	/* on클래스 넣기 end*/

	/* on클래스 넣기(type2) start*/
	$(document).on(
		"click", ".click_add_on_solo", function(){

		var thisNum=$(".click_add_on_solo").index(this);
		var thisAddOnSolo=$(".click_add_on_solo").eq(thisNum);
		var target=thisAddOnSolo.attr("class").replace("click_add_on_solo ","");
		var targetAddOn=$("."+target+"");

		targetAddOn.removeClass("on");
		thisAddOnSolo.addClass("on");
		return false;
	});
	/* on클래스 넣기(type2) end*/

	/* 탭동작 start */
	$(document).on(
		"click", ".tap_type1 li a", function(){
		var theTapArea=$(".tap_wrap .tap_area");
		var thisNum=$(this).parent().index();

		$(this).addClass("on").parent().siblings().children("a").removeClass("on");
		
		theTapArea.eq(thisNum).css("display","block").siblings(".tap_area").css("display","none");
		return false;
	})
	/* 탭동작 end */

	/* 요소 보이기/숨기기 start*/
	$(document).on(
		"click", ".link_btns_wrap .show_btn", function(){

		$(".link_btns_wrap .show_btn").css("display","none");
		$(".link_btns_wrap .link_list").css("display","block");

	});

	$(document).on(
		"click", ".link_btns_wrap .link_list dd .hide_btn", function(){

		$(".link_btns_wrap .show_btn").css("display","block");
		$(".link_btns_wrap .link_list").css("display","none");

	});
	/* 요소 보이기/숨기기 end*/

	/* 멀티셀렉트 start*/
	$(document).on(
		"click", ".fake_select dt", function(){

		var thisNum=$(".fake_select dt").index(this);
		var thisFakeSelect=$(".fake_select dt").eq(thisNum).next("dd");
		
		$(".fake_select dd").slideUp(500);

		if(thisFakeSelect.is(":visible")){
			thisFakeSelect.slideUp(500);
		}else{
			thisFakeSelect.slideDown(500);
		}
		return false;
	});

	$(document).on(
		"change", ".fake_select dd li :checkbox", function(){

		var thisFakeSelectDt=$(this).parents(".fake_select").children("dt").children("input");
		var thisText=$(this).next("span").text();
		var thisDtText=thisFakeSelectDt.val();
		var checkNum=$(this).parents(".fake_select").find(":checked").length;
		
		

		if($(this).is(":checked")){
			if(checkNum>1){
				thisFakeSelectDt.val(thisDtText+","+thisText);
			}else{
				thisFakeSelectDt.val(thisDtText+thisText);
			}
			
		}else{
			if(checkNum==0){
				thisFakeSelectDt.val("");	
			}else{
				thisFakeSelectDt.val(thisFakeSelectDt.val().replace(","+thisText,""));
				thisFakeSelectDt.val(thisFakeSelectDt.val().replace(thisText+",",""));
			}
		}
	});
	/* 멀티셀렉트 end*/
	});
