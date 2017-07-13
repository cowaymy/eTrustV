$(document).ready(function(){
/* 제이쿼리 ui달력 start*/
var pickerOpts={
	changeMonth:true,
	changeYear:true,
	dateFormat: "dd/mm/yy"
};
$(".j_date").datepicker(pickerOpts);

var monthOptions = {
	pattern: 'mm/yyyy',
	selectedYear: 2017,
	startYear: 2007,
	finalYear: 2027
};

$(".j_date2").monthpicker(monthOptions);
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

/*트리메뉴 start */
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
/* 트리메뉴 end */

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
})

$(document).on(
	"change", ":file", function(){
	var thisVal=$(this).val();
	var thisfakeInput=$(this).next().children(".input_text");

	thisfakeInput.val(thisVal);
	})
/* 인풋 파일 end */
})