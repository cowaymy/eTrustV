<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var popSelectedRow = -1;
var grdUser = "";
var grdMenuMapping = "";
var gridDataLength=0;
var gridDetailDataLength=0;
/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {

    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "funcYn") {
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
//         AUIGrid.updateAllToValue(grdMenuMapping, "funcYn", "Y");
        var item = { funcYn : "Y" };
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
            if(AUIGrid.getItemByRowIndex(grdMenuMapping,idx).existYn == "N"){
                AUIGrid.updateRow(grdMenuMapping, item, idx);
            }
        }
    } else {
        var item = { funcYn : "N" };
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
            if(AUIGrid.getItemByRowIndex(grdMenuMapping,idx).existYn == "N"){
                AUIGrid.updateRow(grdMenuMapping, item, idx);
            }
        }
//         AUIGrid.updateAllToValue(grdMenuMapping, "funcYn", "N");
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
};

//특정 칼럼 값으로 체크하기 (기존 더하기)
function addCheckedRowsByValue() {

    // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크함
    AUIGrid.addCheckedRowsByValue(grdMenuMapping, "funcYn", "N");

    // 만약 복수 값(Emma, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
    //AUIGrid.addCheckedRowsByValue(myGridID, "name", ["Emma", "Steve"]);
};

//특정 칼럼 값으로 체크 해제 하기
function addUncheckedRowsByValue() {
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크 해제함
    AUIGrid.addUncheckedRowsByValue(grdMenuMapping, "name", "Emma");
};

//필드값으로 아이템들 얻기
function getItemsByField() {
    // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(grdUser, "funcYn", "Y");
};

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
        alert("No Change Data.");
        return true; /* Failed */
    }

    return false; /* Success */
}
/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
    Common.ajax(
            "GET",
            "/common/selectUserList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                AUIGrid.clearGridData(grdMenuMapping);
                AUIGrid.setGridData(grdUser, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_detailSearch(userId){
    Common.ajax(
            "GET",
            "/common/selectUserMenuMappingList.do",
            "userId="+userId+"&menuCode="+$("#menuCode").val(),
            function(data, textStatus, jqXHR){ // Success
//              alert(JSON.stringify(data));
                AUIGrid.setGridData(grdMenuMapping, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_detailSave(){
    if(fn_checkChangeRows(grdMenuMapping)){
        return;
    }

    var editList = AUIGrid.getEditedRowItems(grdMenuMapping);
    if(editList.length > 0){
        for(var idx = 0 ; idx < editList.length ; idx++){
            if(editList[idx].validDtFrom == "" || typeof(editList[idx].validDtFrom) == "undefined"){
                AUIGrid.selectRowsByRowId(grdMenuMapping, editList[idx].rowId);
                alert("From Date is essential field.");
                return;
            }
            if(editList[idx].validDtTo == "" || typeof(editList[idx].validDtTo) == "undefined"){
                AUIGrid.selectRowsByRowId(grdMenuMapping, editList[idx].rowId);
                alert("To Date is essential field.");
                return;
            }
        }
    }


    if(confirm("Do you want to save it?")){
        Common.ajax(
                "POST",
                "/common/saveUserMenuMappingList.do",
                GridCommon.getEditData(grdMenuMapping),
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

/****************************Transaction End**********************************/
/**************************** Grid setting Start ********************************/
var gridUserColumnLayout =
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
        dataField : "userId",
        /* dataType : "string", */
        headerText : "User Id",
        width : "30%",
    },
    {
        dataField : "userName",
        headerText : "User Name",
        style : "aui-grid-user-custom-left"
    }
];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var options =
{
        editable : false,
        usePaging : true, //페이징 사용
        pagingMode : "simple",
        showPageButtonCount : 3 ,
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

var gridMenuMappingColumnLayout =
[
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
         visible : false
     },
    {
        dataField : "menuLvl",
        /* dataType : "string", */
        headerText : "Lvl",
        editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
        width : "7%"
    },
    {
        dataField : "menuName",
        headerText : "Menu Name",
        width : "25%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "pgmName",
        headerText : "Program Name",
        width : "25%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "pgmTrnName",
        headerText : "Transaction",
        width : "10%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
//     var dayRegExp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
    {
        dataField: "validDtFrom",
        headerText: "From",
        dataType : "date",
        formatString : "yyyy-mm-dd",
        width:"12%",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
            validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
                var date, isValid = true;
                var msg = "";

                if(isNaN(Number(newValue)) ) { //20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
                    if(isNaN(Date.parse(newValue))) { // 그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
                        isValid = false;
                        msg = "Invalid Date Type.";
                    } else {
                        isValid = true;
                    }
                }

                if(isValid){
                    var dtFrom = Number(rowItem.validDtFrom.toString().replace(/\//g,""));
                    var dtTo = Number(rowItem.validDtTo.toString().replace(/\//g,""));
                    if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
                        msg = "Start date can not be greater than End date.";
                        isValid = false;
                    }
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : msg };
        }
        }
    },
    {
        dataField: "validDtTo",
        headerText: "To",
        dataType : "date",
        formatString : "yyyy-mm-dd",
        width:"12%",
        editRenderer : {
            type : "CalendarRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
            onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
            validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
                var date, isValid = true;
                var msg = "";

                if(isNaN(Number(newValue)) ) { //20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
                    if(isNaN(Date.parse(newValue))) { // 그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
                        isValid = false;
                        msg = "Invalid Date Type.";
                    } else {
                        isValid = true;
                    }
                }

                if(isValid){
                    var dtFrom = Number(rowItem.validDtFrom.toString().replace(/\//g,""));
                    var dtTo = Number(rowItem.validDtTo.toString().replace(/\//g,""));
                    if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
                        msg = "Start date can not be greater than End date.";
                        isValid = false;
                    }
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : msg };
        }
        }
    },
    {
        dataField : "funcYn",
        headerText : "<input type='checkbox' id='allCheckbox' style='width:15px;height:15px;''>",
        width:"8%",
        editable : true,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                if(item.existYn == "Y") {
                    return "disable-check-style";
                }
                return null;
            },
            // 체크박스 disabled 함수
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.existYn == "Y")
                    return true; // true 반환하면 disabled 시킴
                return false;
            }
//          // 체크박스 Visible 함수
//          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
//              if(item.charge == "Anna")
//                  return false; // 책임자가 Anna 인 경우 체크박스 표시 안함.
//              return true;
//          }
        }
    },
    {
        dataField : "ownerYn",
        headerText : "Owner Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
    },
    {
        dataField : "existYn",
        headerText : "Exist Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
    },
    {
        dataField : "baseYn",
        headerText : "Baseauth Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
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
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제

};


/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    grdUser = GridCommon.createAUIGrid("grdUser", gridUserColumnLayout,"", options);
    // ready 이벤트 바인딩
    AUIGrid.bind(grdUser, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(grdUser).length; // 그리드 전체 행수 보관
    });

    // click 이벤트 바인딩
    AUIGrid.bind(grdUser, ["cellClick"], function(event) {
        selectedRow = event.rowIndex;
        fn_detailSearch(event.item.userId);
    });

    grdMenuMapping = GridCommon.createAUIGrid("grdMenuMapping", gridMenuMappingColumnLayout,"", detailOptions);

    AUIGrid.bind(grdMenuMapping, ["cellDoubleClick"], function(event) {
//      if(event.dataField == "validDtFrom" || event.dataField == "validDtTo") {
//          AUIGrid.setCellValue(grdMenuMapping, event.rowIndex, event.dataField, "");
//         }
    });

    AUIGrid.bind(grdMenuMapping, "ready", function(event) {
        gridDetailDataLength = AUIGrid.getGridData(grdMenuMapping).length; // 그리드 전체 행수 보관

//      for(var idx = 0 ; idx < gridDetailDataLength ; idx++){

//      }
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(grdMenuMapping, "headerClick", headerClickHandler);

    AUIGrid.bind(grdMenuMapping, ["cellEditBegin"], function(event) {
        // ExistYn 가 "Y" 인 경우, validDtTo, validDtTo 수정 못하게 하기
        if(event.dataField == "validDtFrom" || event.dataField == "validDtTo") {
            if(event.item.existYn == "Y") {
                return false; // false 반환. 기본 행위인 편집 불가
            }
        }
    });

    // 셀 수정 완료 이벤트 바인딩 (checkAll)
    AUIGrid.bind(grdMenuMapping, "cellEditEnd", function(event) {
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "funcYn") {
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(grdMenuMapping, "funcYn", "Y");
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDetailDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }

     // ExistYn 가 "Y" 인 경우, validDtTo, validDtTo 수정 못하게 하기
        if(event.dataField == "validDtFrom" || event.dataField == "validDtTo"){
            var dtFrom = event.item.validDtFrom;
            var dtTo = event.item.validDtTo;
            var oldValue = event.oldValue;

            if(typeof(event.item.validDtFrom) == "undefined") dtFrom = "";
            if(typeof(event.item.validDtTo) == "undefined") dtTo = "";
            if(typeof(event.item.oldValue) == "undefined") oldValue = "";

            dtFrom = Number(dtFrom.toString().replace(/\//g,""));
            dtTo = Number(dtTo.toString().replace(/\//g,""));

            if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
                alert("Start date can not be greater than End date.");
                AUIGrid.setCellValue(grdMenuMapping, event.rowIndex, event.dataField, event.oldValue);
            }
        }
     /*
        if(event.dataField == "validDtTo") {
            var dtFrom = event.item.validDtFrom;
            var dtTo = event.item.validDtTo;
            if(typeof(event.item.validDtFrom) == "undefined") dtFrom = "";
            if(typeof(event.item.validDtTo) == "undefined") dtTo = "";

            dtFrom = Number(dtFrom.replace("/",""));
            dtTo = Number(dtFrom.replace("/",""));

            if(dtFrom > to){
                alert("Start date can not be greater than End date.");
                AUIGrid.setCellValue(grdMenuMapping, event.rowIndex, event.dataField, event.oldValue);
            }
        }
     */
    });

    AUIGrid.clearGridData(grdUser);
    AUIGrid.clearGridData(grdMenuMapping);

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

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
    color:#d3825c;
}

</style>

<section id="content"><!-- content start -->
<ul class="path">
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>User Menu Mapping</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a  onclick="fn_detailSave()">Save</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span>Search</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="#" method="post">

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
    <th scope="row">User</th>
    <td>
    <input id="userCode" name="userCode" type="text" title="" value="" placeholder="User ID or Name" class="" />
    </td>
    <th scope="row">Menu</th>
    <td>
    <input id="menuCode" name="menuCode" type="text" title="" value="" placeholder="Menu Code or Name" class="" />
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

<div class="border_box" style="width:25%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">User</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdUser" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<div class="border_box" style="width:75%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Menu</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdMenuMapping" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- divine_auto end -->

</section><!-- search_result end -->

</section><!-- content end -->