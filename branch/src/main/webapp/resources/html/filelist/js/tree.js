$(document).ready(function(){
//트리메뉴 시작
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
		thisLi.children("a").before("<img src='images/btn_plus.gif' alt='하위메뉴 보기' />");
	}
}

var treeBtn=$(".treeMenu li img");

treeBtn.click(function(){
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
})