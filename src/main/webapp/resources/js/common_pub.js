$(document).ready(function(){
/* 제이쿼리 ui달력 start*/

var holidays = {//휴일 세팅 하기
    /*"0809":{type:0, title:"신정", year:"2017"}*/
};

var isLoadHoliday = false;

var pickerOpts = {//일반년월일달력 세팅
	changeMonth: true,
	changeYear: true,
	dateFormat: "dd/mm/yy",
	beforeShowDay: function (day) {

        if (!isLoadHoliday) {

            isLoadHoliday = true;

            try{
                // get holiday list
                Common.ajaxSync("GET", "/common/getPublicHolidayList.do", {}, function (result) {
                    for (var idx = 0; idx < result.length; idx++) {
                        holidays[result[idx].mmdd] = {
                            type: 0,
                            title: result[idx].holidayDesc,
                            year: result[idx].yyyy
                        };
                    }
                });
			}catch(e){
                Common.removeLoader();
            	console.log("common_pub.js => getHolidays fail : " + e);
			}
        }

		var result;
		// 포맷에 대해선 다음 참조(http://docs.jquery.com/UI/Datepicker/formatDate)
		var holiday = holidays[$.datepicker.formatDate("mmdd", day)];
		var thisYear = $.datepicker.formatDate("yy", day);

		// exist holiday?
		if (holiday) {
			if (thisYear == holiday.year || holiday.year == "") {
				result = [true, "date-holiday", holiday.title];
			}
		}

		if (!result) {
			switch (day.getDay()) {
				case 0: // is sunday?
					result = [true, "date-sunday"];
					break;
				case 6: // is saturday?
					result = [true, "date-saturday"];
					break;
				default:
					result = [true, ""];
					break;
			}
		}

		return result;
	}
};

$(document).on(//일반년월일달력 실행
	"focus", ".j_date", function(){
	$(this).datepicker(pickerOpts);
});

/* Input에 초기값(today) 출력
$(document).ready(function(){
	var d = new Date();
	var month = d.getMonth()+1;
	var day = d.getDate();

	var output = (day<10 ? '0' : '') + day + '/' +
	    (month<10 ? '0' : '') + month + '/' +
	    d.getFullYear() ;
	$(".j_date").val(output);
})
*/

// 2018. 01. 03 add jgkim
// before => selectedYear: 2017
//			 => startYear: 2007
//			 => finalYear: 2027
var nowYear = new Date().getFullYear();
var monthOptions = {//년월달력 세팅
	pattern: 'mm/yyyy',
	selectedYear: nowYear,
	startYear: Number(nowYear) - 10,
	finalYear: Number(nowYear) + 10
};

$(document).on(//년월달력 실행
	"focus", ".j_date2", function(){
	$(this).monthpicker(monthOptions).bind('monthpicker-show',function(e){
		if($(".ui-datepicker").offset().left < $(this).offset().left){
			$(".ui-datepicker").css('left',$(this).offset().left-$(".ui-datepicker").width()/2)
		}
	});
});

var pickerOpts2 = {//생년월일달력 세팅
	changeMonth:true,
	changeYear:true,
	defaultDate: new Date(1960, 00, 01),
	dateFormat: "dd/mm/yy",
	yearRange:"1930:2000"
};

$(document).on(//생년월일달력 실행
	"focus", ".j_date3", function(){
	$(this).datepicker(pickerOpts2);
});
/* 제이쿼리 ui달력 end*/

/* 아코디언메뉴 start */
$(document).on(
	"click", "dl .click_add_on", function(){

	var thisNum=$("dl .click_add_on").index(this);
	var thisAddOn=$("dl .click_add_on").eq(thisNum);

	thisAddOn.toggleClass("on");
	return false;
});
/* 아코디언메뉴 end*/

/* lnb탭 start*/
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
/* lnb탭 end*/

/* 탭동작 start */
$(document).on(
	"click", ".tap_type1 li a", function(){
	var theTapArea=$(this).parents(".tap_wrap").children(".tap_area");
	var thisNum=$(this).parents().index();

	$(this).addClass("on").parent().siblings().children("a").removeClass("on");
	theTapArea.eq(thisNum).show().siblings(".tap_area").hide();
	/*theTapArea.eq(thisNum).css("position","relative").css("top","0").siblings(".tap_area").css("position","absolute").css("top","-1000em");*/
	return false;
})
/* 탭동작 end */

/* 링크버튼 숨기기/보이기 start*/
$(document).on(
	"click", ".link_btns_wrap .show_btn", function(){

	$(".link_btns_wrap .show_btn").css("display","none");
	$(".link_btns_wrap .link_list").css("display","block");
	return false;

});

$(document).on(
	"click", ".link_btns_wrap .link_list dd .hide_btn", function(){

	$(".link_btns_wrap .show_btn").css("display","block");
	$(".link_btns_wrap .link_list").css("display","none");
	return false;
});
/* 링크버튼 숨기기/보이기 end*/

 /* 멀티셀렉트 플러그인 start */
 $('.multy_select').on("change", function() {
	//console.log($(this).val());
}).multipleSelect({
	width: '100%',
	// Callback 
	onOpen: function() {
		// 팝업의 세로길이가 짧아서 Select 박스가 가려질 경우
		if($("#popup_wrap").is(":visible")){
			multipleSelectPopupFn("open");
		}
 		// alert("Open");
	},
	onClose: function() {
 		// alert("Close");
		// 팝업의 세로길이가 짧아서 Select 박스가 가려질 경우의 초기값
		if($("#popup_wrap").is(":visible")){
			multipleSelectPopupFn("close");
		}
	},
	onCheckAll: function() {
        // alert('Check all clicked!');
    },
    onUncheckAll: function() {
        // alert('Uncheck all clicked!');
    },
	onClick: function(view) {
 		// alert(view.label);
	}
});

// 팝업의 세로길이가 짧아서 Select 박스가 가려질 경우 처리함수
function multipleSelectPopupFn(eTarget){
	var popupHeight = $(".pop_body").height(),
		popupMaxHeight = $(".pop_body").css("max-height").replace(/[^-\d\.]/g, '');

	if(popupHeight < popupMaxHeight){
		if(eTarget == "open"){
			var newHeight = $(".pop_body").prop("scrollHeight");
			$(".pop_body").css("height",newHeight);
		} else if(eTarget == "close"){
			$(".pop_body").css("height","auto");
		}
	}
}

/*LNB start */
$(document).on(
	"click", ".inb_menu li a", function(){
	var thisLi=$(this).parent("li");
	var thisHasChild=thisLi.children("ul").length;
	var thisUl=$(this).parent().parent("ul").find("li ul");
	if(thisHasChild>0){
		if(thisLi.children("ul").is(":visible")){
			$(this).removeClass("on")
			thisLi.children("ul").slideUp("500");
		}else{
			thisUl.parent("li").children("a").removeClass("on")
			thisUl.slideUp("500");
			$(this).addClass("on")
			thisLi.children("ul").slideDown("500");
		}
		//$(this).removeClass("on");
		return false;
	}else{
	}
});

/* 레프트메뉴 3뎁스 하위메뉴 (4뎁스)가 있을 경우 앞에 화살표 표시 on/off */ 
$(document).ready(function(){
	var depth3 = $(".inb_menu").children("li").children("ul").children("li").children("ul").children("li");

	for( var i=0; i < depth3.length; i++ ){
		if(!depth3.eq(i).children("ul").length>0){
			depth3.eq(i).children("a").addClass("none");
		}
	}
})
/* LNB end */

//트리메뉴 시작
function setTree(){//트리메뉴 세팅
	var treeBtn=$(".treeMenu a");
	var treeLi=$(".treeMenu li");
	var firstLi=$(".treeMenu>ul>li:first-child");
	var lastLi=$(".treeMenu ul li:last-child");
	var lastUl=lastLi.children("ul");

	firstLi.addClass("first");
	lastLi.addClass("last");
	lastUl.addClass("last");

	for(var i=0; i<treeLi.length; i++){
	var thisLi=treeLi.eq(i);
	var haveUl=thisLi.children("ul");
	var haveUlNum=haveUl.length;
	var thisbg=thisLi.attr("class");

		if(haveUlNum=="0"){
			if(thisbg=="first"){
				 thisLi.addClass("none_first");
			}else if(thisbg=="last"){
				thisLi.addClass("none_last");
			}else{
				thisLi.addClass("none");
			}
		}else if(haveUlNum!="0"){
			if(haveUl.is(":visible")){
				thisLi.children("a").before("<img src='../images/common/btn_minus.gif' alt='하위메뉴 보기' />");
			}else{
				thisLi.children("a").before("<img src='../images/common/btn_plus.gif' alt='하위메뉴 보기' />");
			}
			
		}
	}
}
// setTree();//트리메뉴 세팅 함수 실행

function reSetTree(){//트리메뉴 재세팅 함수 실행
	$(".treeMenu li").removeClass();
	$(".treeMenu li img").remove();
	setTree();
}

$(document).on(
	"click", ".treeMenu li img", function(){
	var treeBtn=$(".treeMenu li img");
	var thisNum=treeBtn.index(this);
	var thisBtn=treeBtn.eq(thisNum);
	var thisSubUl=thisBtn.parent().children("ul");

	if(thisSubUl.is(":visible")){
		thisBtn.attr("src",thisBtn.attr("src").replace("minus.gif","plus.gif"));
		thisSubUl.slideUp("500");
	}else{
		thisBtn.attr("src",thisBtn.attr("src").replace("plus.gif","minus.gif"));
		thisSubUl.slideDown("500");
	}
})
//트리메뉴 끝

/* 인풋 파일 start */
function setInputFile(){//인풋파일 세팅하기
	$(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}
setInputFile();

function setReInputFile(){//인풋파일 재세팅
	$(":file+label").remove();
	$(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
	for(var i=0; i<=$(":file").length; i++){
		$(".auto_file .input_text").eq(i).val($(":file").eq(i).val());
	}
}

function setHaveInputFile(){//인풋파일 있을경우
	var autoFl = $(".auto_file label .input_text");
	for(var i=0; i<autoFl.length; i++){
		var flVal = $(".auto_file input[type=file]:eq("+i+")").attr("value"),
			flUpd = $(".auto_file label .input_text:eq("+i+")");
		if( flVal ){
			flUpd.val(flVal);
		} else {
			flUpd.val("");
		};
	}
}
setHaveInputFile();

$(document).on(//인풋파일 실행
	"click", ".label_text a", function(){
	var thisFileInput=$(this).parent().parent().prev(":file");

	thisFileInput.click();	
	return false;
});

$(document).on(
	"change", ":file", function(){
	var thisVal=$(this).val();
	var thisfakeInput=$(this).next().children(".input_text");

	thisfakeInput.val(thisVal);

	try{
		// 첨부파일 변경시 처리 함수.. : 본문에 구현이 되어야 호출 됨...
		fn_abstractChangeFile(thisfakeInput);
	}catch(e){
		//본문에 함수가 없다면.... 무시..
	}
});
/* 인풋 파일 end */

/* 인풋 파일(멀티) start */
function setInputFile2(){//인풋파일 세팅하기
	$(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}
setInputFile2();

$(document).on(//인풋파일 추가
	"click", ".auto_file2 a:contains('Add')", function(){

	$(".auto_file2:last-child").clone().insertAfter(".auto_file2:last-child");
	$(".auto_file2:last-child :file, .auto_file2:last-child :text").val("");
	$(".auto_file2:last-child :file, .auto_file2:last-child :text").attr("data-id", "");
	return false;
});

$(document).on(//인풋파일 삭제
	"click", ".auto_file2 a:contains('Delete')", function(){
	var fileNum=$(".auto_file2").length;

	if(fileNum <= 1){

	}else{
		$(this).parents(".auto_file2").remove();

        try{
            var thisfakeInput=$(this).parent().prev().prev().children(".input_text");
            // 첨부파일 삭제시 처리 함수.. : 본문에 구현이 되어야 호출 됨...
            fn_abstractDeleteFile(thisfakeInput);
        }catch(e){
			//본문에 함수가 없다면.... 무시..
        }
	}

	return false;
});
/* 인풋 파일(멀티) end */

/* 팝업 드래그 start */
$(".popup_wrap").draggable({handle: ".pop_header",containment: "html"});
/* 팝업 드래그 end */

/* 팝업 닫기 start */
 $(document).on(
	"click", ".pop_header .right_opt a:contains('CLOSE') ,.pop_close", function(){

	/* common.js 를 통한 div popup은 div remove를 해 줘야 함. */
	if($(this).closest('div[name="_popupDiv"]').attr("manualClose")){
        $(this).closest('div[name="_popupDiv"]').remove();
	}else if($(this).closest('div').attr("autoClose")){
		// manual close...
	}else{

       var thisPopupWrap=$(this).closest(".popup_wrap");
        thisPopupWrap.fadeOut();
	}
	return false;
});

 function popupKeyEvent(target){
	 $(document).on("keydown",function(e){
	 	// ESC
	 	if(e.keyCode === 27){
	 		target.trigger('click');
	 	}
	 });
 }
 $(document).on("click",function(e){
 	if($(e.target).parent().attr("id") === "popup_wrap"){
 		var target = $(e.target).parent().find(".pop_header .right_opt a:contains('CLOSE') ,.pop_close");	
 		popupKeyEvent(target);
	}
 });
/* 팝업 닫기 start */

/* 시간선택기 start */
 $(document).on(
	"focus", ".time_date", function(){
	$(this).next("ul").fadeIn(500);
});

 $(document).on(
	"focusout", ".time_date", function(){
	$(this).next("ul").fadeOut(500);
});

 $(document).on(
	"click", ".time_picker > ul li a ", function(){
	$(this).parents(".time_picker").children(".time_date").val($(this).text());
	return false;
});
/* 시간선택기 end */


/* 아코디언테이블 start */
 $(document).on(
	"click", ".aco_btn", function(){
	 if($(this).parents("tr").next("tr").is(":visible")){
		$(this).children("img").attr("src",$(this).children("img").attr("src").replace("up.gif","down.gif"));
		$(this).parents("tr").next("tr").css("display","none");
	 }else{
		$(this).children("img").attr("src",$(this).children("img").attr("src").replace("down.gif","up.gif"));
		$(this).parents("tr").next("tr").css("display","table-row");
	 }
	return false;
});
/* 아코디언테이블 end */


/* 코웨이아이템 start */
$(document).on(
	"mouseenter", ".item_list > li", function(){
	var thinInner=$(this).children(".inner");
	thinInner.stop().animate({top:-150},300);
});

$(document).on(
	"mouseleave", ".item_list > li", function(){
	var thinInner=$(this).children(".inner");
	thinInner.stop().animate({top:0},300);
});
 /* 코웨이아이템 end */
});
