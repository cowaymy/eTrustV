$(function(){
	"use strict";
	/*
	 * Document Ready
	 */
	$(document).ready(function(){
		// Left Navigation
		lnbFn();
	});

	/*
	 * Left Menu Tree Event
	 */
	$(document).on(
		"click", ".inb_menu li a", function(){
		var thisLi=$(this).parent("li");
		var thisHasChild=thisLi.children("ul").length;
		var thisUl=$(this).parent().parent("ul").find("li ul");
		if(thisHasChild>0){
			if(thisLi.children("ul").is(":visible")){
				$(this).removeClass("on");
				thisLi.children("ul").slideUp(500);
			}else{
				thisUl.parent("li").children("a").removeClass("on");
				thisUl.slideUp(500);
				$(this).addClass("on");
				thisLi.children("ul").slideDown(500);
			}
			//$(this).removeClass("on");
			return false;
		}
	});
	
	/*
	 * Left Navigation Function
	 */
	function lnbFn(){
		var navBg = $(".nav_wrap"),
			navContainer = $(".nav_container"),
			navBtn = $(".btn-nav"),
			navClosed = $(".btn-close"),
			navExtended = 0,
			navDecreased = -(navBg.width()),
			animateSpeed = 300;

		navBtn.on("click",function(){
			navBg.show();
			navContainer.css("left",navDecreased);
			navContainer.animate({
				left : navExtended
			},animateSpeed);
		});
		navClosed.on("click",function(){
			navContainer.animate({
				left : navDecreased
			},animateSpeed,function(){
				navBg.hide();
			});
		});
		navBg.on("click",function(evt){
			var target = $(evt.target);
			if (target.is(navBg)) {
			  navClosed.trigger("click");
			}
		});
		//레프트메뉴 3뎁스 하위메뉴 (4뎁스)가 있을 경우 앞에 화살표 표시 on/off
		var depth3 = $(".inb_menu").children("li").children("ul").children("li").children("ul").children("li");

		for( var i = 0; i < depth3.length; i++ ){
			if(!depth3.eq(i).children("ul").length > 0){
				depth3.eq(i).children("a").addClass("none");
			}
		}
	};
});

/* 탭동작 start */
$(document).on(
	"click", ".tap_type1 li a", function(){
	var theTapArea=$(this).parents(".tap_wrap").children(".tap_area");
	var thisNum=$(this).parents().index();
	
	$(this).addClass("on").parent().siblings().children("a").removeClass("on");
	
	theTapArea.eq(thisNum).css("position","relative").css("top","0").siblings(".tap_area").css("position","absolute").css("top","-1000em");
	return false;
})
/* 탭동작 end */