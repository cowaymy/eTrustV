<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>                              
<script type="text/javaScript">
/********************************Function  Start***************************************/ 
// 행 추가, 삽입
var cnt = 0;

function addRow() {
           
    var item = new Object();
    //Column Layout에 없더라도 추가됨
    item.myMenuCode = "";
    item.myMenuName = "";
    item.myMenuOrd = "";
    item.useYn = "Y";

    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridID, item, "first");
};

// 행 삭제
function delRow() {			
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5        
    AUIGrid.removeRow(myGridID, "selectedIndex");
};

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
    
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "chkAll") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
            checkAll(isChecked);
        }
        return false;
    }
};

// 전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
        AUIGrid.updateAllToValue(myGridID, "chkAll", "Y");
    } else {
        AUIGrid.updateAllToValue(myGridID, "chkAll", "N");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
};

//필드값으로 아이템들 얻기
function getItemsByField() {    
    // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(myGridID, "chkAll", "Y");            
};

/**************************** Function  End ***********************************/
/**
 *  Transaction Start
 */

function fn_search(){
	Common.ajax(
		    "GET", 
		    "/common/selectMyMenuList.do", 
		    $("#searchForm").serialize(), 
		    function(data, textStatus, jqXHR){ // Success		  		    	
		    	AUIGrid.setGridData(myGridID, data);
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	alert("Fail : " + jqXHR.responseJSON.message);
		    }		    
	)
};

function fn_save(){
	if(confirm("Do you want to save it?")){				
		Common.ajax(
	            "POST", 
	            "/common/saveMyMenuList.do", 
	            GridCommon.getEditData(myGridID),
	            function(data, textStatus, jqXHR){ // Success
	            	alert("Saved.");
	                fn_search();
	            },
	            function(jqXHR, textStatus, errorThrown){ // Error
	                alert("Fail : " + jqXHR.responseJSON.message);
	            }           
	    )	
	}	
};
 
 
/**
 *  Transaction End
 */
 
 
 
/**************************** Grid setting Start ********************************/
var gridMasterColumnLayout =
[ 
    /*
	{
        dataField : "chkAll",
        headerText : "<input type='checkbox' id='allCheckbox' style='width:15px;height:15px;''>",
        width:"8%",
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        }
    },
    */
    {       
        dataField : "mymenuCode",
        /* dataType : "string", */
        headerText : "Grp Code",
        width : "20%"
    }, 
    {
        dataField : "mymenuName",
        headerText : "Grp Name",
        width : "40%",
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "mymenuOrder",
        headerText : "Order",
        width : "15%"
    }, 
    {
        dataField : "useYn",
        headerText : "UseYn",
        /* width: "15%",         */
        /*
        styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
            if(value == "Y") {
                return "Yes";
            } else if(value == "N") {
                return "No";
            }
            return "";
        },
        */
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        /*    
            //사용자가 체크 상태를 변경하고자 할 때 변경을 허락할지 여부를 지정할 수 있는 함수 입니다.
            checkableFunction :  function(rowIndex, columnIndex, value, isChecked, item, dataField ) {
                // 행 아이템의 charge 가 Anna 라면 수정 불가로 지정. (기존 값 유지)
                if(item.charge == "Anna") {
                    return false;
                }
                return true;
            }
        */    
        }
    }    
];

var options = 
{
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

var myGridID = "";
var gridDataLength=0;

$(document).ready(function(){
    // AUIGrid 그리드를 생성
    myGridID = GridCommon.createAUIGrid("myMenuGrp", gridMasterColumnLayout,"", options);
    // ready 이벤트 바인딩
    AUIGrid.bind(myGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(myGridID).length; // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(myGridID, "headerClick", headerClickHandler); 
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, ["cellEditBegin"], function(event) {
        /*
    	// Country 가 "Korea", "UK" 인 경우, Name, Product 수정 못하게 하기        
        if(event.dataField == "name" || event.dataField == "product") {
            if(event.item.country == "Korea" || event.item.country == "UK") {
                return false; // false 반환. 기본 행위인 편집 불가
            }
        }
        */
        
    });
    
    // 셀 수정 완료 이벤트 바인딩 (checkAll)
    AUIGrid.bind(myGridID, "cellEditEnd", function(event) {        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "chkAll") {            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(myGridID, "chkAll", "Y");            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });
});
/*Grid Setting End*/
</script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
        

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>My Menu Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span>Search</a></p></li>    
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="" method="GET">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MenuGrp</th>
    <td>
    <input id="mymenuCode" name="mymenuCode" type="text" title="" placeholder="" class="" />
    </td>
    <th scope="row"></th>
    <td>
    <input type="text" title="" placeholder="" class="" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<!--
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
 -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">My Menu Group</h3>
<ul class="right_opt">
    <li><p class="btn_grid"><a onclick="addRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delRow()">Del</a></p></li>
    <li><p class="btn_grid"><a onclick="fn_save()">Save</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="myMenuGrp" style="height:420px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:50%;">

<div class="border_box" style="height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">My Menu</h3>
<ul class="right_opt">
    <li><p class="btn_grid"><a onclick="addRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delRow()">Del</a></p></li>
    <li><p class="btn_grid"><a onclick="fn_save()">Save</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wraps"><!-- grid_wrap start -->
    <div id="myMenu"  style="height:420px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->