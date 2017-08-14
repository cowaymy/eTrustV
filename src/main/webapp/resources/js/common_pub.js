$(document).ready(function(){
/* 제이쿼리 ui달력 start*/

var holidays = {//휴일 세팅 하기
    /*"0809":{type:0, title:"신정", year:"2017"}*/
};


var pickerOpts={//일반년월일달력 세팅
	changeMonth:true,
	changeYear:true,
	dateFormat: "dd/mm/yy",
		beforeShowDay: function(day) {
		var result;
		// 포맷에 대해선 다음 참조(http://docs.jquery.com/UI/Datepicker/formatDate)
		var holiday = holidays[$.datepicker.formatDate("mmdd",day )];
		var thisYear = $.datepicker.formatDate("yy", day);

		// exist holiday?
		if (holiday) {
			if(thisYear == holiday.year || holiday.year == "") {
				result =  [true, "date-holiday", holiday.title];
			}
		}

		if(!result) {
			switch (day.getDay()) {
				case 0: // is sunday?
					result = [false, "date-sunday"];
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

$(".j_date").datepicker(pickerOpts);//일반년월일달력 실행

var monthOptions = {//생년월일 세팅
	pattern: 'mm/yyyy',
	selectedYear: 2017,
	startYear: 2007,
	finalYear: 2027
};

$(".j_date2").monthpicker(monthOptions);//생년월일 실행


var pickerOpts2 = {//생년월일 세팅
	changeMonth:true,
	changeYear:true,
	defaultDate: new Date(1960, 00, 01),
	dateFormat: "dd/mm/yy",
	yearRange:"1930:2000"
};


$(".j_date3").datepicker(pickerOpts2);//생년월일 달력
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
	var theTapArea=$(this).parents(".tap_wrap").children(".tap_area");
	var thisNum=$(this).parents().index();
	
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
	return false;

});

$(document).on(
	"click", ".link_btns_wrap .link_list dd .hide_btn", function(){

	$(".link_btns_wrap .show_btn").css("display","block");
	$(".link_btns_wrap .link_list").css("display","none");
	return false;
});
/* 요소 보이기/숨기기 end*/

 /* 멀티셀렉트 플러그인 start */
 $('.multy_select').change(function() {
	console.log($(this).val());
})

.multipleSelect({
	width: '100%'
});
 /* 멀티셀렉트 플러그인 start */

/*LNB start */
$(document).on(
	"click", ".inb_menu li a", function(){
	var thisLi=$(this).parent("li");
	var thisHasChild=thisLi.children("ul").length;

	

	if(thisHasChild>0){
		if(thisLi.children("ul").is(":visible")){
			thisLi.children("ul").slideUp("500");
		}else{
			thisLi.children("ul").slideDown("500");
		}
		$(this).toggleClass("on");
		return false;
	}else{
	}
});
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
setTree();//트리메뉴 세팅 함수 실행

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
function setInputFile(){
	var theFile=$(":file");
	$(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}
setInputFile();

$(document).on(
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
});
/* 인풋 파일 end */

/* 팝업 드래그 start */
$("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
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

       var thisPopupWrap=$(this).closest("#popup_wrap, .popup_wrap");
        thisPopupWrap.fadeOut();
	}
	return false;
});
/* 팝업 닫기 start */

/* 시간선택기 start */
 $(document).on(
	"focus", ".time_date ", function(){
	$(this).next("ul").fadeIn(500);
});

 $(document).on(
	"focusout", ".time_date ", function(){
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
});