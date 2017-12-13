<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var _popSelectedRow = -1;
var grdAccess = null;
var grdAccessDtm = null;
var grdAccessUser = null;
var gridDataLength=0;
/*공통팝업 조회ID*/
var _queryId = "";
var keyValueList = null;


/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
function lpad(param, length, str) {
    param = param + ""
    return param.length >= length ? param : new Array(length - param.length + 1).join(str) + param;
}
/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
	if($("input[name=searchDivCd]:checked").val() == "1"){
		Common.ajax(
	            "GET",
	            "/common/selectAccessMonitoringList.do",
	            $("#searchForm").serialize(),
	            function(data, textStatus, jqXHR){ // Success
	                AUIGrid.clearGridData(grdAccess);
	                AUIGrid.setGridData(grdAccess, data);
	                Common.setMsg("Search Success.");
	            },
	            function(jqXHR, textStatus, errorThrown){ // Error
	                alert("Fail : " + jqXHR.responseJSON.message);
	                Common.setMsg("Search Failed.");
	            }
	    )
	}else if($("input[name=searchDivCd]:checked").val() == "2"){
		Common.ajax(
	            "GET",
	            "/common/selectAccessMonitoringDtmList.do",
	            $("#searchForm").serialize(),
	            function(data, textStatus, jqXHR){ // Success
	            	AUIGrid.clearGridData(grdAccessUser);
	                AUIGrid.clearGridData(grdAccessDtm);
	                AUIGrid.setGridData(grdAccessDtm, data);
	                Common.setMsg("Search Success.");
	            },
	            function(jqXHR, textStatus, errorThrown){ // Error
	                alert("Fail : " + jqXHR.responseJSON.message);
	                Common.setMsg("Search Failed.");
	            }
	    )
	}
};

function fn_detailSearch(_systemId,_searchDt,_pgmCode){
    Common.ajax(
            "GET",
            "/common/selectAccessMonitoringUserList.do",
            "systemId="+_systemId+"&searchDt="+_searchDt+"&pgmCode="+_pgmCode,
            function(data, textStatus, jqXHR){ // Success
            	AUIGrid.clearGridData(grdAccessUser);
                AUIGrid.setGridData(grdAccessUser, data);
                Common.setMsg("Search Success.");
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
                Common.setMsg("Search Failed.");
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
var grdAccessColumnLayout =
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
         dataField : "pgmCode",
         headerText : "Program",
         width : "7%",
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
         dataField : "pgmName",
         headerText : "Program Name",
         width : "18%",
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
     },

     {
         dataField : "pgmPath",
         headerText : "Program Path",
         style : "aui-grid-user-custom-left",
         width : "21%",
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
        dataField : "userId",
        headerText : "User Id",
        width : "9%",
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
       dataField : "userName",
       headerText : "User Name",
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
        dataField : "ipAddr",
        headerText : "IP",
        width : "12%",
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
        dataField : "accessDtm",
        dataType : "date",
        headerText : "Access Time",
        formatString : "yyyy-mm-dd hh:MM:ss",
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
    }
];

var grdAccessDtmColumnLayout =
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
         width:"12%",
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
         dataField : "pgmCode",
         headerText : "Program Code",
         width : "16%",
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
         dataField : "pgmName",
         headerText : "Program Name",
         width : "27%",
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
     },
     {
         dataField : "accessDay",
         headerText : "Access Day",
         dataType : "date",
         width:"18%",
         formatString : "yyyy-mm-dd",
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
        dataField : "accessTime",
        headerText : "Access Time",
        width : "13%",
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
       dataField : "accessDtmCnt",
       headerText : "Count",
       style : "aui-grid-user-custom-right",
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
   }
];

var grdAccessUserColumnLayout =
[
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
         visible : false
     },
     {
        dataField : "userId",
        headerText : "User Id",
        width : "20%",
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
       dataField : "userName",
       headerText : "User Name",
       width : "30%",
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
       dataField : "accessDtm",
       headerText : "Access Time",
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
   }
];



var accessOptions =
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

    // radio change 이벤트
    $("input[name=searchDivCd]").change(function() {
        var rdoVal = $(this).val();
        if (rdoVal == "1") {
            $("#layoutBasic").attr("style","");
            $("#layoutByTime").attr("style","display:none");
        } else if (rdoVal == "2") {
        	$("#layoutBasic").attr("style","display:none");
            $("#layoutByTime").attr("style","");
        }
    });

    grdAccess = GridCommon.createAUIGrid("grdAccess", grdAccessColumnLayout,"", accessOptions);
    grdAccessDtm = GridCommon.createAUIGrid("grdAccessDtm", grdAccessDtmColumnLayout,"", accessOptions);
    grdAccessUser = GridCommon.createAUIGrid("grdAccessUser", grdAccessUserColumnLayout,"", accessOptions);

    AUIGrid.bind(grdAccess, "ready", function(event) {
    	gridDataLength = AUIGrid.getGridData(grdAccess).length; // 그리드 전체 행수 보관
    });

    // click 이벤트 바인딩
    AUIGrid.bind(grdAccessDtm, ["cellClick"], function(event) {
        selectedRow = event.rowIndex;
        var searchDt = event.item.accessTime + event.item.accessDay.toString().replace(/\//g,"");
        fn_detailSearch(event.item.systemId, searchDt ,event.item.pgmCode);
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    //AUIGrid.bind(grdAccess, "headerClick", headerClickHandler);

    AUIGrid.clearGridData(grdAccess);

    $("#layoutBasic").attr("style","");
    $("#layoutByTime").attr("style","display:none");

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
<h2>Access Monitoring</h2>
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
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
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
    <th scope="row">Program</th>
    <td>
    <input id="pgmCode" name="pgmCode" type="text" style="width:200px;" value="" placeholder="Program Code or Name" class="" />
    </td>
</tr>
<tr>
    <th scope="row">User</th>
    <td>
    <input id="userId" name="userId" type="text" style="width:200px;" value="" placeholder="User ID or Name" class="" />
    </td>
    <th scope="row">IP</th>
    <td>
    <input id="ipAddr" name="ipAddr" type="text" style="width:200px;" value=""  placeholder="IP Address" class="" />
    </td>
    <th scope="row">Division</th>
    <td>
    <label><input type="radio" name="searchDivCd" value="1" checked />Basic</label>
    <label><input type="radio" name="searchDivCd" value="2" />By time</label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->


<div id="layoutBasic" class="divine_auto" style="">
<div class="border_box" style="width:100%;height:450px;padding: 0 0 0 0px;"><!-- border_box start -->
<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Access Monitor</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdAccess"  style="height:420px;"></div>
</article><!-- grid_wrap end -->
</div>
</div>

<div id="layoutByTime" class="divine_auto" style="">

<div class="border_box" style="width:70%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Access Monitor</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdAccessDtm"  style="height:420px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<div class="border_box" style="width:30%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Access User</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdAccessUser"  style="height:420px;"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>



</section><!-- search_result end -->

</section><!-- content end -->