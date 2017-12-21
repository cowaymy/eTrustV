<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var _popSelectedRow = -1;
var grdIf = "";
var gridDataLength=0;
/*공통팝업 조회ID*/
var _queryId = "";
var _callbackFunc = "popupCallback";
//var keyValueList = [{code:"0", value:"Department"}, {code:"1", value:"Branch"}];
var keyValueList = null;
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
function addRow() {
    var item = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(grdIf, item, "first");
};

// 행 삭제
function delRow() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(grdIf, "selectedIndex");
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


function popupCallback(result){
    AUIGrid.setCellValue(grdIf, _popSelectedRow, "authCode", result.id);
    AUIGrid.setCellValue(grdIf, _popSelectedRow, "authName", result.name);
}

/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
	Common.ajax(
		    "GET",
		    "/common/selectInterfaceManagementList.do",
		    $("#searchForm").serialize(),
		    function(data, textStatus, jqXHR){ // Success
		    	AUIGrid.clearGridData(grdIf);
		    	AUIGrid.setGridData(grdIf, data);
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	alert("Fail : " + jqXHR.responseJSON.message);
		    }
	)
};

function fn_detailSave(){
	if(fn_checkChangeRows(grdIf)){
		return;
	}

    var addList = AUIGrid.getAddedRowItems(grdIf);
    if(addList.length > 0){
        for(var idx = 0 ; idx < addList.length ; idx++){
        	if(addList[idx].ifType == "" || typeof(addList[idx].ifType) == "undefined"){
                AUIGrid.selectRowsByRowId(grdIf, addList[idx].rowId);
                alert("IF TYPE is essential field.");
                return;
            }
        }
    }

    if(confirm("Do you want to save it?")){
        Common.ajax(
                "POST",
                "/common/saveInterfaceManagementList.do",
                GridCommon.getEditData(grdIf),
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

function fn_commCodesearch(){
    Common.ajax(
            "GET",
            "/common/selectCommonCodeList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
            	keyValueList = data;
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};
/****************************Transaction End**********************************/
/**************************** Grid setting Start ********************************/

var gridIfColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
	 {
         dataField : "ifType",
         headerText : "IF TYPE",
         width:"7%",
         editRenderer : {
             type : "InputEditRenderer",

             // 에디팅 유효성 검사
             validator : function(oldValue, newValue, item, dataField) {
                 var isValid = false;

                 if(newValue.length <= 5) {
                     isValid = true;
                 }

                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                 return { "validate" : isValid, "message"  : "The maximum of characters is 5 "};
             }
         }
     },
	 {
        dataField : "ifTypeNm",
        headerText : "IF TYPE NAME",
        width : "20%",
        style : "aui-grid-user-custom-left",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 200) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
            }
        }
	},
    {
       dataField : "ifSnd",
       headerText : "Sender",
       width : "10%",
       style : "aui-grid-user-custom-left",
       editRenderer : {
           type : "InputEditRenderer",

           // 에디팅 유효성 검사
           validator : function(oldValue, newValue, item, dataField) {
               var isValid = false;

               if(newValue.length <= 30) {
                   isValid = true;
               }
               // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
               return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
           }
       }
   },
   {
      dataField : "ifRcv",
      headerText : "Receiver",
      width : "10%",
      style : "aui-grid-user-custom-left",
      editRenderer : {
          type : "InputEditRenderer",

          // 에디팅 유효성 검사
          validator : function(oldValue, newValue, item, dataField) {
              var isValid = false;

              if(newValue.length <= 30) {
                  isValid = true;
              }
              // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
              return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
          }
      }
    },
    {
        dataField : "chkCol",
        headerText : "CHK Column",
        width : "10%",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 30) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 30 "};
            }
        }
    },
    {
        dataField : "bizCol",
        headerText : "BIZ Column",
        width : "10%",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 30) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 30 "};
            }
        }
    },
    {
        dataField : "tableNm",
        headerText : "Table Name",
        width : "10%",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 100) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 100 "};
            }
        }
    },
    {
        dataField : "dscnNm",
        headerText : "Descrption",
        style : "aui-grid-user-custom-left",
        editRenderer : {
            type : "InputEditRenderer",

            // 에디팅 유효성 검사
            validator : function(oldValue, newValue, item, dataField) {
                var isValid = false;

                if(newValue.length <= 200) {
                    isValid = true;
                }
                // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                return { "validate" : isValid, "message"  : "The maximum of characters is 200 "};
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
//         selectionMode : "multipleRows",
        selectionMode : "multipleCells",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};


/****************************Program Init Start********************************/
$(document).ready(function(){
    grdIf = GridCommon.createAUIGrid("grdIf", gridIfColumnLayout,"", detailOptions);
    AUIGrid.bind(grdIf, ["cellDoubleClick"], function(event) {
//     	if(event.dataField == "validDtFrom" || event.dataField == "validDtTo") {
//     		AUIGrid.setCellValue(grdIf, event.rowIndex, event.dataField, "");
//         }
    });

    AUIGrid.bind(grdIf, "ready", function(event) {
    	gridDataLength = AUIGrid.getGridData(grdIf).length; // 그리드 전체 행수 보관

//     	for(var idx = 0 ; idx < gridDataLength ; idx++){

//     	}
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    //AUIGrid.bind(grdIf, "headerClick", headerClickHandler);

    AUIGrid.bind(grdIf, ["cellEditBegin"], function(event) {
        // ExistYn 가 "Y" 인 경우, validDtTo, validDtTo 수정 못하게 하기
        if(event.dataField == "ifType") {
        	if(AUIGrid.isAddedById(event.pid, event.item.rowId)) {
                return true;
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
    });

    // 셀 수정 완료 이벤트 바인딩 (checkAll)
    AUIGrid.bind(grdIf, "cellEditEnd", function(event) {
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "funcYn") {
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(grdIf, "funcYn", "Y");
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });
    AUIGrid.clearGridData(grdIf);
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
<h2>Interface Management</h2>
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
    <th scope="row">IF Type</th>
    <td>
    <input id="ifType" name="ifType" type="text" title="" value=""  placeholder="Type Code or Name" class="" />
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
<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Interface Master</h3>
<ul class="right_opt">
    <li><p class="btn_grid"><a onclick="addRow()">Add</a></p></li>
    <li><p class="btn_grid"><a onclick="delRow()">Del</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap autoHeight"><!-- grid_wrap start -->
    <div id="grdIf"  style="height:425px;"></div>
</article><!-- grid_wrap end -->

<!-- </div> -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->