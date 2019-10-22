<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var _popSelectedRow = -1;
var grdUser = "";
var grdAddAuth = "";
var gridDataLength=0;
var gridDetailDataLength=0;
/*공통팝업 조회ID*/
var _queryId = "";
var _callbackFunc = "popupCallback";
//var keyValueListTemp = [{code:"0", value:"Department"}, {code:"1", value:"Branch"}];
var keyValueList = [];
/*
function resizeHandler(aryHeight) {
    $(window).resize(function() {
        var bHeight = $("body").height();

        $(".grid_wrap.autoHeight").each(function(i) {
            var sHeight = bHeight - aryHeight[i];
            if ( sHeight < 200 ) sHeight = 200;  // Height 최소값 지정.

            if (bHeight != 200) {
                $(this).height(sHeight);
            }
        });
    });
    $(window).resize();
};
*/
/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
function addDetailRow() {
    var item = new Object();
    //Column Layout에 없더라도 추가됨
    item.userId = AUIGrid.getCellValue(grdUser, selectedRow, "userId");

    if(item.userId == "" || item.userId == null) {
        Common.alert("<spring:message code='sys.msg.necessary' arguments='User ID' htmlEscape='false'/>");
        return;
    }

    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(grdAddAuth, item, "first");
};

// 행 삭제
function delDetailRow() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(grdAddAuth, "selectedIndex");
};

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
//         AUIGrid.updateAllToValue(grdAddAuth, "funcYn", "Y");
        var item = { funcYn : "Y" };
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
            if(AUIGrid.getItemByRowIndex(grdAddAuth,idx).existYn == "N"){
                AUIGrid.updateRow(grdAddAuth, item, idx);
            }
        }
    } else {
        var item = { funcYn : "N" };
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
            if(AUIGrid.getItemByRowIndex(grdAddAuth,idx).existYn == "N"){
                AUIGrid.updateRow(grdAddAuth, item, idx);
            }
        }
//         AUIGrid.updateAllToValue(grdAddAuth, "funcYn", "N");
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
};

//특정 칼럼 값으로 체크하기 (기존 더하기)
function addCheckedRowsByValue() {

    // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크함
    AUIGrid.addCheckedRowsByValue(grdAddAuth, "funcYn", "N");

    // 만약 복수 값(Emma, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
    //AUIGrid.addCheckedRowsByValue(myGridID, "name", ["Emma", "Steve"]);
};

//특정 칼럼 값으로 체크 해제 하기
function addUncheckedRowsByValue() {
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크 해제함
    AUIGrid.addUncheckedRowsByValue(grdAddAuth, "name", "Emma");
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
        Common.alert("<spring:message code='sys.common.alert.noChange'/>");
        return true; /* Failed */
    }

    return false; /* Success */
}


function popupCallback(result){
    AUIGrid.setCellValue(grdAddAuth, _popSelectedRow, "authCode", result.id);
    AUIGrid.setCellValue(grdAddAuth, _popSelectedRow, "authName", result.name);
}

/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
    Common.ajax(
            "GET",
            "/common/selectUserList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                AUIGrid.clearGridData(grdAddAuth);
                AUIGrid.setGridData(grdUser, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_detailSearch(userId){
    Common.ajax(
            "GET",
            "/common/selectUserAddAuthList.do",
            "userId="+userId,
            function(data, textStatus, jqXHR){ // Success
//              alert(JSON.stringify(data));
                AUIGrid.setGridData(grdAddAuth, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_detailSave(){
    if(fn_checkChangeRows(grdAddAuth)){
        return;
    }

    var addList = AUIGrid.getAddedRowItems(grdAddAuth);
    if(addList.length > 0){
        for(var idx = 0 ; idx < addList.length ; idx++){
            if(addList[idx].authDivCode == "" || typeof(addList[idx].authDivCode) == "undefined"){
                AUIGrid.selectRowsByRowId(grdAddAuth, addList[idx].rowId);
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Div Code' htmlEscape='false'/>");
                sys.msg.necessary
                return;
            }
            if(addList[idx].authCode == "" || typeof(addList[idx].authCode) == "undefined"){
                AUIGrid.selectRowsByRowId(grdAddAuth, addList[idx].rowId);
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
                return;
            }
            if(addList[idx].validDtFrom == "" || typeof(addList[idx].validDtFrom) == "undefined"){
                AUIGrid.selectRowsByRowId(grdAddAuth, addList[idx].rowId);
                Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
                return;
            }
            if(addList[idx].validDtTo == "" || typeof(addList[idx].validDtTo) == "undefined"){
                AUIGrid.selectRowsByRowId(grdAddAuth, addList[idx].rowId);
                Common.alert("<spring:message code='sys.msg.necessary' arguments='From Date' htmlEscape='false'/>");
                return;
            }
        }
    }

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "POST",
                "/common/saveUserAddAuthList.do",
                GridCommon.getEditData(grdAddAuth),
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>");
                    fn_search();
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};

function fn_commCodesearch(){
    Common.ajax(
            "GET",
            "/common/selectCommonCodeList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                keyValueList = data;
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            },
            {async: false}
    )
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

//공통코드 조회
fn_commCodesearch();

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

var gridAddAuthColumnLayout =
[
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
         visible : false
     },
     {
         dataField : "authDivCode",
         headerText : "Div",
         width:"15%",
         labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
             var retStr = value;
             for(var i=0,len=keyValueList.length; i<len; i++) {
                 if(keyValueList[i]["code"] == value) {
                     retStr = keyValueList[i]["value"];
                     break;
                 }
             }
             return retStr;
         },
         editRenderer : {
             type : "DropDownListRenderer",
             list : keyValueList, //key-value Object 로 구성된 리스트
             keyField : "code", // key 에 해당되는 필드명
             valueField : "value" // value 에 해당되는 필드명
         }
     },
     {
        dataField : "authCode",
        /* dataType : "string", */
        headerText : "Code",
        editable : false,
        width : "15%",
           renderer : {
               type : "IconRenderer",
               iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
               iconHeight : 24,
               iconPosition : "aisleRight",
               iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                 "default" : "/resources/images/common/normal_search.png" //
               },
               onclick : function(rowIndex, columnIndex, value, item) {
                  if(AUIGrid.isAddedById("#grdAddAuth", item.rowId)) {
                      _popSelectedRow = rowIndex;
                      if(item.authDivCode == "0"){
                          _queryId = "selectDepartmentList";
                      }else if(item.authDivCode ==  "1"){
                          _queryId = "selectBranchList";
                      }else{
                          _queryId = "";
                      }
                      var popUpObj = Common.popupDiv
                      (
                           "/common/commonMyPop.do"
                           , ""
                           , null
                           , "false"
                           , "commonMyPop"
                      );

                  }
               }
           }
        },
    {
        dataField : "authName",
        headerText : "Name",
        width : "30%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
//     var dayRegExp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
    {
        dataField: "validDtFrom",
        headerText: "From",
        dataType : "date",
        formatString : "yyyy-mm-dd",
        width:"20%",
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
        width:"20%",
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
    }/* ,
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
    }              */

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

    grdAddAuth = GridCommon.createAUIGrid("grdAddAuth", gridAddAuthColumnLayout,"", detailOptions);
    AUIGrid.bind(grdAddAuth, ["cellDoubleClick"], function(event) {
//      if(event.dataField == "validDtFrom" || event.dataField == "validDtTo") {
//          AUIGrid.setCellValue(grdAddAuth, event.rowIndex, event.dataField, "");
//         }
    });

    AUIGrid.bind(grdAddAuth, "ready", function(event) {
        gridDetailDataLength = AUIGrid.getGridData(grdAddAuth).length; // 그리드 전체 행수 보관

//      for(var idx = 0 ; idx < gridDetailDataLength ; idx++){

//      }
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(grdAddAuth, "headerClick", headerClickHandler);

    AUIGrid.bind(grdAddAuth, ["cellEditBegin"], function(event) {
        // ExistYn 가 "Y" 인 경우, validDtTo, validDtTo 수정 못하게 하기
        if(event.dataField == "authDivCode" || event.dataField == "authCode" || event.dataField == "validDtFrom") {
            if(AUIGrid.isAddedById(event.pid, event.item.rowId)) {
                return true;
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
    });

    // 셀 수정 완료 이벤트 바인딩 (checkAll)
    AUIGrid.bind(grdAddAuth, "cellEditEnd", function(event) {
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "funcYn") {
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(grdAddAuth, "funcYn", "Y");
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

            dtFrom = dtFrom.toString().replace(/\//g,"");
            dtTo = dtTo.toString().replace(/\//g,"");

            var numDtFrom = Number(dtFrom.toString().replace(/\//g,""));
            var numDtTo = Number(dtTo.toString().replace(/\//g,""));

            if(numDtFrom != 0 && numDtTo != 0 && numDtFrom > numDtTo){
                Common.alert("Start date can not be greater than End date.");
                AUIGrid.setCellValue(grdAddAuth, event.rowIndex, event.dataField, event.oldValue);
            }else{
                if(event.dataField == "validDtFrom"){
                     AUIGrid.setCellValue(grdAddAuth, event.rowIndex, event.dataField, dtFrom);
                }else if(event.dataField == "validDtTo"){
                     AUIGrid.setCellValue(grdAddAuth, event.rowIndex, event.dataField, dtTo);
                }

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
                AUIGrid.setCellValue(grdAddAuth, event.rowIndex, event.dataField, event.oldValue);
            }
        }
     */
    });
    AUIGrid.clearGridData(grdUser);
    AUIGrid.clearGridData(grdAddAuth);
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
<h2>User Additional Auth</h2>
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
    <!-- <col style="width:110px" />
    <col style="width:*" /> -->
</colgroup>
<tbody>
<tr>
    <th scope="row">User</th>
    <td>
    <input id="userCode" name="userCode" type="text" title="" value=""  placeholder="User ID or Name" class="" />
    </td>
    <!-- <th scope="row">Menu</th>
    <td>
    <input id="menuCode" name="menuCode" type="text" title="" value="" placeholder="" class="" />
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

<!-- <div style="width:25%;"> -->

<div class="border_box" style="width:35%;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">User</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdUser" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<!-- </div> -->

<!-- <div style="width:75%;"> -->

<div class="border_box" style="width:65%;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Auth</h3>
<ul class="right_opt">
    <li><p class="btn_grid"><a onclick="addDetailRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delDetailRow()">Del</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap autoHeight"><!-- grid_wrap start -->
    <div id="grdAddAuth" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<!-- </div> -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->