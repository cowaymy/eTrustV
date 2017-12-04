<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var popSelectedRow = -1;
var myGridID = "";
var myGridDetailID = "";
var gridDataLength=0;
/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
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

function addDetailRow() {
    var item = new Object();
    //Column Layout에 없더라도 추가됨
    item.mymenuCode = AUIGrid.getCellValue(myGridID, selectedRow, "mymenuCode");
    item.mymenuName = AUIGrid.getCellValue(myGridID, selectedRow, "mymenuName");

    if(item.mymenuCode == "" || item.mymenuCode == null) {
    	Common.alert("My Menu Code is Null or not saved.");
    	return;
    }

    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(myGridDetailID, item, "first");
};

// 행 삭제
function delDetailRow() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(myGridDetailID, "selectedIndex");
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


function popupCallback(result){
	AUIGrid.setCellValue(myGridDetailID, popSelectedRow, "menuCode", result.menuCode);
	AUIGrid.setCellValue(myGridDetailID, popSelectedRow, "menuName", result.menuName);
}


function fn_checkChangeRows(gridId,mandatoryItems){
    var addList = AUIGrid.getAddedRowItems(gridId);
    // 수정된 행 아이템들(배열)
    //var updateList = AUIGrid.getEditedRowColumnItems(gridId);
    var updateList = AUIGrid.getEditedRowItems(gridId);
    // 삭제된 행 아이템들(배열)
    var removeList = AUIGrid.getRemovedItems(gridId);

    var totalLength = 0;
    totalLength = addList.length + updateList.length + removeList.length;

	if(totalLength == 0){
		return true; /* Failed */
	}

	return false; /* Success */
}
/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
	Common.ajax(
		    "GET",
		    "/common/selectMyMenuList.do",
		    $("#searchForm").serialize(),
		    function(data, textStatus, jqXHR){ // Success
		    	AUIGrid.clearGridData(myGridDetailID);
		    	AUIGrid.setGridData(myGridID, data);

		        Common.setMsg("Menu Group Search Success.");
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	Common.alert("Fail : " + jqXHR.responseJSON.message);
		    	Common.setMsg("Failed.");
		    }
	)
};

function fn_save(){
	if(fn_checkChangeRows(myGridID)){
		Common.alert("<spring:message code='sys.common.alert.noChange'/>");
        return;
    }
	var addList = AUIGrid.getAddedRowItems(myGridID);
    if(addList.length > 0){
        for(var idx = 0 ; idx < addList.length ; idx++){
            if(addList[idx].mymenuCode == "" || typeof(addList[idx].mymenuCode) == "undefined"){
                AUIGrid.selectRowsByRowId(myGridID, addList[idx].rowId);
                Common.alert("<spring:message code='sys.msg.necessary' arguments='MyMenuCode' htmlEscape='false'/>");
                return;
            }
        }
    }

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
    	Common.ajax(
                "POST",
                "/common/saveMyMenuList.do",
                GridCommon.getEditData(myGridID),
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>");
                    fn_search();
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    alert("Fail : " + jqXHR.responseJSON.message);
                    Common.setMsg("Failed.");
                }
        )
    });

};

function fn_detailSearch(mymenuCode){
    Common.ajax(
            "GET",
            "/common/selectMyMenuProgrmList.do",
            "mymenuCode="+mymenuCode,
            function(data, textStatus, jqXHR){ // Success
                AUIGrid.setGridData(myGridDetailID, data);
                Common.setMsg("<spring:message code='sys.msg.success'/>");
            },
            function(jqXHR, textStatus, errorThrown){ // Error
            	Common.alert("Fail : " + jqXHR.responseJSON.message);
                Common.setMsg("<spring:message code='sys.msg.fail'/>");
            }
    )
};

function fn_detailSave(){
	if(fn_checkChangeRows(myGridDetailID)){
		Common.alert("<spring:message code='sys.common.alert.noChange'/>");
		return;
	}

	var addList = AUIGrid.getAddedRowItems(myGridDetailID);
	if(addList.length > 0){
		for(var idx = 0 ; idx < addList.length ; idx++){
			if(addList[idx].mymenuCode == "" || typeof(addList[idx].mymenuCode) == "undefined"){
				AUIGrid.selectRowsByRowId(myGridDetailID, addList[idx].rowId);
				Common.alert("<spring:message code='sys.msg.necessary' arguments='My Menu Code' htmlEscape='false'/>");
                return;
            }
			if(addList[idx].menuCode == "" || typeof(addList[idx].menuCode) == "undefined"){
				AUIGrid.selectRowsByRowId(myGridDetailID, addList[idx].rowId);
				Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu Code' htmlEscape='false'/>");
				return;
			}
		}
	}


    Common.confirm("<spring:message code='sys.common.alert.save'/>",
    		function(){
            Common.ajax(
	                "POST",
	                "/common/savetMyMenuProgrmList.do",
	                GridCommon.getEditData(myGridDetailID),
	                function(data, textStatus, jqXHR){ // Success
	                	Common.alert("<spring:message code='sys.msg.success'/>");
	                    fn_search();
	                },
	                function(jqXHR, textStatus, errorThrown){ // Error
	                    Common.alert("Fail : " + jqXHR.responseJSON.message);
	                }
	        )
        }
    );
};

/****************************Transaction End**********************************/
/**************************** Grid setting Start ********************************/
var gridMasterColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
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
        editable : true, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
        width : "20%",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;
                var matcher = /^[A-Za-z0-9+]{1,10}$/;

                if(matcher.test(newValue)) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "Only numbers can be entered.[Digits 10]" };
            }
        }

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
        width : "15%",
        editRenderer : {
            type : "InputEditRenderer",
            onlyNumeric : true, // Input 에서 숫자만 가능케 설정
            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item) {
                var isValid = false;
                var numVal = Number(newValue);
                if(!isNaN(numVal) && numVal < 100) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "Only numbers can be entered.[Below 100]" };
            }
        }
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

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var options =
{
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "multipleRows",
        editBeginMode : "click", // 편집모드 클릭
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

var gridDetailColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
	{
	    dataField : "mymenuCode",
	    /* dataType : "string", */
	    headerText : "Grp Code",
	    editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
	    width : "15%"
	},
	{
	    dataField : "mymenuName",
	    headerText : "Grp Name",
	    editable : false,
	    width : "20%",
	    style : "aui-grid-user-custom-left"
	},
    {
        dataField : "menuCode",
        /* dataType : "string", */
        headerText : "Menu Code",
        editable : false,
        width : "25%",
           renderer : {
               type : "IconRenderer",
               iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
               iconHeight : 24,
               iconPosition : "aisleRight",
               iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                 "default" : "/resources/images/common/normal_search.png" //
               },
               onclick : function(rowIndex, columnIndex, value, item) {
                  if(AUIGrid.isAddedById("#myMenu", item.rowId)) {
                	  popSelectedRow = rowIndex;
                      var popUpObj = Common.popupDiv
                      (
                           "/common/menuPop.do"
                   	       , ""
                   	       , null
                   	       , "false"
                   	       , "menuPop"
                   	  );

                  }
               }
           }
    },
    {
        dataField : "menuName",
        headerText : "Menu Name",
        width : "25%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "pgmOrd",
        headerText : "Order",
       	editRenderer : {
               type : "InputEditRenderer",
               onlyNumeric : true, // Input 에서 숫자만 가능케 설정
               // 에디팅 유효성 검사
               validator : function(oldValue, newValue, item) {
                   var isValid = false;
                   var numVal = Number(newValue);
                   if(!isNaN(numVal) && numVal < 100) {
                       isValid = true;
                   }
                   // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                   return { "validate" : isValid, "message"  : "Only numbers can be entered.[Below 100]" };
               }
           }
    }
];

var detailOptions =
{
		editable : true,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "multipleRows",
        editBeginMode : "click", // 편집모드 클릭
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};


/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    myGridID = GridCommon.createAUIGrid("myMenuGrp", gridMasterColumnLayout,"", options);
    // ready 이벤트 바인딩
    AUIGrid.bind(myGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(myGridID).length; // 그리드 전체 행수 보관
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(myGridID, "headerClick", headerClickHandler);

    // click 이벤트 바인딩
    AUIGrid.bind(myGridID, ["cellClick"], function(event) {
    	selectedRow = event.rowIndex;
    	fn_detailSearch(event.item.mymenuCode);
    });

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(myGridID, ["cellEditBegin"], function(event) {
    	if(event.dataField == "mymenuCode") {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.isAddedById(event.pid, event.item.rowId)) {
                return true;
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
        return true; // 다른 필드들은 편집 허용
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

    myGridDetailID = GridCommon.createAUIGrid("myMenu", gridDetailColumnLayout,"", detailOptions);

    AUIGrid.bind(myGridDetailID, ["cellClick"], function(event) {

    });

    AUIGrid.clearGridData(myGridID);
    AUIGrid.clearGridData(myGridDetailID);
});
/****************************Program Init End********************************/
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
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>My Menu Management</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span>Search</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="" method="GET">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <!--
    <col style="width:110px" />
    <col style="width:*" />
    -->
</colgroup>
<tbody>
<tr>
    <th scope="row">MenuGrp</th>
    <td>
    <input id="mymenuCode" name="mymenuCode" type="text" title="" placeholder="My Menu Code or Name" class="" />
    </td>
<!--     <th scope="row"></th>
    <td>
    <input type="text" title="" placeholder="" class="" />
    </td> -->
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

<div class="border_box" style="width:50%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">My Menu Group</h3>
<ul class="right_opt">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a onclick="addRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delRow()">Del</a></p></li>
    <li><p class="btn_grid"><a onclick="fn_save()">Save</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="myMenuGrp" style="height:425px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<div class="border_box" style="width:50%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">My Menu</h3>
<ul class="right_opt">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a onclick="addDetailRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delDetailRow()">Del</a></p></li>
    <li><p class="btn_grid"><a onclick="fn_detailSave()">Save</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->

<article class="grid_wraps"><!-- grid_wrap start -->
    <div id="myMenu"  style="height:425px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->