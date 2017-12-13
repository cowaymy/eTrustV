<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var _popSelectedRow = -1;
var grdLogin = "";
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
    AUIGrid.addRow(grdLogin, item, "first");
};

// 행 삭제
function delRow() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(grdLogin, "selectedIndex");
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
    AUIGrid.setCellValue(grdLogin, _popSelectedRow, "authCode", result.id);
    AUIGrid.setCellValue(grdLogin, _popSelectedRow, "authName", result.name);
}


function lpad(param, length, str) {
    param = param + ""
    return param.length >= length ? param : new Array(length - param.length + 1).join(str) + param;
}

/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){

	Common.ajax(
		    "GET",
		    "/common/selectLoginMonitoringList.do",
		    $("#searchForm").serialize(),
		    function(data, textStatus, jqXHR){ // Success
		    	AUIGrid.clearGridData(grdLogin);
		    	AUIGrid.setGridData(grdLogin, data);
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	alert("Fail : " + jqXHR.responseJSON.message);
		    }
	)
};

function fn_commCodesearch(){
    Common.ajax(
            "GET",
            "/common/selectCommonCodeSystemList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
            	 for(var idx = 0 ; idx < data.length ; idx++){
            		 $("#systemId").append("<option value='"+data[idx].code+"'>"+data[idx].value+"</option>");
            	 }
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
         dataField : "systemId",
         headerText : "System",
         width:"3%",
         visible : false
     },
     {
         dataField : "systemNm",
         headerText : "System",
         width:"10%",
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
         dataField : "loginDtm",
         headerText : "Login Time",
         width:"17%",
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
        dataField : "userId",
        headerText : "User Id",
        width : "8%",
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
       dataField : "userNm",
       headerText : "User Name",
       width : "12%",
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
      dataField : "loginType",
      headerText : "Type",
      width : "8%",
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
        dataField : "ipAddr",
        headerText : "IP",
        width : "13%",
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
        dataField : "os",
        headerText : "OS",
        style : "aui-grid-user-custom-left",
        width : "13%",
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
        dataField : "browser",
        headerText : "Browser",
        style : "aui-grid-user-custom-left",
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
    }
];

var detailOptions =
{
		editable : false,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};


/****************************Program Init Start********************************/
$(document).ready(function(){

    grdLogin = GridCommon.createAUIGrid("grdLogin", gridIfColumnLayout,"", detailOptions);

    AUIGrid.bind(grdLogin, "ready", function(event) {
    	gridDataLength = AUIGrid.getGridData(grdLogin).length; // 그리드 전체 행수 보관

//     	for(var idx = 0 ; idx < gridDataLength ; idx++){

//     	}
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    //AUIGrid.bind(grdLogin, "headerClick", headerClickHandler);

    AUIGrid.clearGridData(grdLogin);

    var currentFullDt = new Date();
    currentFullDt.setMonth(currentFullDt.getMonth());
    var beforeFullDt = new Date();
    beforeFullDt.setMonth(beforeFullDt.getMonth() - 1);

    beforeFullDt.setDate(beforeFullDt.getDate() - 7);

    var currentDt = lpad(currentFullDt.getDate(),2,"0")+"/"+lpad(currentFullDt.getMonth()+1,2,"0")+"/"+currentFullDt.getFullYear();
    var beforeDt = lpad(beforeFullDt.getDate(),2,"0")+"/"+lpad(beforeFullDt.getMonth()+1,2,"0")+"/"+beforeFullDt.getFullYear();

    $("#frDate").val(beforeDt);
    $("#toDate").val(currentDt);
    //공통코드 조회
    fn_commCodesearch();


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
<p class="fav"><a href="#" class="click_add_on">Monitoring</a></p>
<h2>Login Monitoring</h2>
<ul class="right_btns">
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
    <th scope="row">System</th>
    <td>
    <select class="" style="width:100px;" id="systemId" name="systemId">
    </select>
    </td>
    <th scope="row">Search Date</th>
    <td colspan="">
        <div class="date_set"><!-- date_set start -->
            <p><input id="frDate" name="frDate" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
            <span>~</span>
            <p><input id="toDate" name="toDate"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">User</th>
    <td>
    <input id="userId" name="userId" type="text" title="" value=""  placeholder="User ID or Name" class="" />
    </td>
    <th scope="row">IP</th>
    <td>
    <input id="ipAddr" name="ipAddr" type="text" title="" value=""  placeholder="IP Address" class="" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto"><!-- divine_auto start -->
<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Login Monitoring</h3>
</aside><!-- title_line end -->

<article class="grid_wrap autoHeight"><!-- grid_wrap start -->
    <div id="grdLogin"  style="height:390px;"></div>
</article><!-- grid_wrap end -->

<!-- </div> -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->