<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}
.aui-grid-drop-list-ul {
   text-align:left;
}
</style>
<script type="text/javaScript">
var assignGrid;
var excelGrid;

var companyList = [];
var agentList = [];
var suggestList = [];
var ynData = [{"codeId": "1","codeName": "YES"},{"codeId": "0","codeName": "NO"}];


$(document).ready(function(){

	doDefCombo(ynData, '' ,'etrYn', 'S', '');                 //Status 생성
	doDefCombo(ynData, '' ,'sensitiveYn', 'S', '');                 //Status 생성
    //Application Type
    CommonCombo.make("appType", "/common/selectCodeList.do", {groupCode : '10'}, '66',
    		{
		        id: "codeId",
		        name:"codeName",
		        isShowChoose: false
		      });
    //orderStatus
    CommonCombo.make('orderStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 27} , '4',
    		{
		    	id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.
		        isShowChoose: false
		    });
    //rentalStatus
    CommonCombo.make('rentalStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS',
    		{
	    	    id: "code",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.
		        isShowChoose: false,
		        isCheckAll : false,
		        type : 'M'
		        });
    //Customer Type
    CommonCombo.make("customerType", "/common/selectCodeList.do", {groupCode : '8'}, '964', {isShowChoose: false});
    //Company Type
    CommonCombo.make("companyType", "/common/selectCodeList.do", {groupCode : '95'}, '', {isShowChoose: false , isCheckAll : false, type: "M"});
    //Opening Aging Month
    CommonCombo.make("openMonth", "/common/selectCodeList.do", {groupCode : '330'}, '4|!|5|!|6',
    		{
                id: "code",
                name:"codeName",
                isShowChoose: false ,
                isCheckAll : false,
                type: "M"
             });
    //RosCaller
    CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1'}, '',  {id:"agentId", name:"agentName", isCheckAll : false, isShowChoose: false , type: "M"});
    //doGetCombo('/common/selectCodeList.do', '2', '',    'cmbRaceId',    'S', ''); //Common Code
    CommonCombo.make('cmbRaceId', "/common/selectCodeList.do", {groupCode : '2'} , '',
            {
                id: "codeId",              // 콤보박스 value 에 지정할 필드명.
                name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                isShowChoose: false,
                isCheckAll : true,
                type : 'M'
                });
    $("#companyType").multipleSelect("disable");
    fn_companyList();
    fn_agentList();
    fn_suggestList();

    createGrid();

   /*  $("#customerType").on("change", function () {
    	 var $this = $(this);

         if ($this.val() == 965) {
             $("#companyType").attr("disabled", false);
             $("#companyType").attr("class" , "");
         }else{
        	 $("#companyType").attr("disabled", true);
        	 $("#companyType").attr("class" , "disabled");
         }
    }); */

    //엑셀 다운
    $('#excelDown').click(function() {
       GridCommon.exportTo("excelGrid", 'xlsx', "RCMS Assign List");
    });

   // fn_selectListAjax();
});


function fn_companyList(){

    Common.ajax("GET", "/common/selectCodeList.do", {groupCode : '95'}, function(result) {
    	companyList = result;
        console.log(companyList);
    }, null, {async : false});
}


//Ros caller
function fn_agentList(){

    Common.ajax("GET", "/sales/rcms/selectRosCaller", {stus:'1'}, function(result) {
    	agentList = result;
        console.log(agentList);
    }, null, {async : false});
}

//suggest Caller
function fn_suggestList(){

    Common.ajax("GET", "/sales/rcms/selectRosCaller", '', function(result) {
    	suggestList = result;
        console.log(suggestList);
    }, null, {async : false});
}



function createGrid(){

        var assignColLayout = [
              {dataField : "salesOrdId", headerText : "", width : 90  , visible:false   },
              {dataField : "typeId", headerText : "", width : 90  , visible:false   },
              {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '7%' , editable       : false   },
              {dataField : "custId", headerText : '<spring:message code="sal.title.text.customerBrId" />', width : '7%' , editable       : false       },
              {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : '15%' , editable       : false        },
              {dataField : "corpTypeId", headerText : '<spring:message code="sal.title.text.companyBrType" />', width : '10%', 	  editable       : false
                  /* , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                      var retStr = value;
                      for(var i=0,len=companyList.length; i<len; i++) {
                          if(companyList[i]["codeId"] == value) {
                              retStr = companyList[i]["codeName"];
                              break;
                          }
                      }
                                  return retStr;
	              }
	            , editRenderer : {
	                  type       : "DropDownListRenderer",
	                  list       : companyList, //key-value Object 로 구성된 리스트
	                  keyField   : "codeId", // key 에 해당되는 필드명
	                  valueField : "codeName" // value 에 해당되는 필드명
	              } */
              },
              {dataField : "race", headerText : '<spring:message code="sal.text.race" />', width : '7%',       editable       : false},
              {dataField : "colctTrget", headerText : '<spring:message code="sal.title.text.openOsBrTarget" />', width : '7%'  , editable       : false,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "rentAmt", headerText : '<spring:message code="sal.title.text.currBrOs" />', width : '7%'  , editable       : false ,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "openMthAging", headerText : '<spring:message code="sal.title.text.openAgingBrMonth" />', width : '7%'  , editable       : false      } ,
              {dataField : "unBillAmt", headerText : '<spring:message code="sal.text.unbillAmount" />', width : '10%'  , editable       : false      } ,
              {dataField : "currRentalStus", headerText : '<spring:message code="sal.title.text.currRentStatus" />', width : '10%'  , editable       : false      } ,
              /*   ,{dataField : "suggestAgent", headerText : '<spring:message code="sal.title.text.suggestBrCaller" />', width : 90    , editable       : false     , style:"aui-grid-drop-list-ul"
            	  , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                  var retStr = value;
                  for(var i=0,len=suggestList.length; i<len; i++) {
                      if(suggestList[i]["agentId"] == value) {
                          retStr = suggestList[i]["agentName"];
                          break;
                      }
                  }
	                              return retStr;
	              }
	           editRenderer : {
	                  type       : "DropDownListRenderer",
	                  list       : agentList, //key-value Object 로 구성된 리스트
	                  keyField   : "agentId", // key 에 해당되는 필드명
	                  valueField : "agentName" // value 에 해당되는 필드명
	              }
	            } , */
	          {dataField : "prevAgentId", headerText : "", width : 90    ,   visible:false ,   editable       : false},
	          {dataField : "oriPrevAgentId", headerText : '<spring:message code="sal.title.text.prevCaller" />', width : '14%'    ,    editable       : false } ,
              {dataField : "agentId", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : '14%'    ,     editable       : false ,
	        	  /* style:"aui-grid-drop-list-ul"
                  , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                      var retStr = '';
                      for(var i=0,len=agentList.length; i<len; i++) {
                          if(agentList[i]["agentId"] == value) {
                              retStr = agentList[i]["agentName"];
                              break;
                          }
                      }
                                  return retStr;
	              }
	            , editRenderer : {
	                  type       : "DropDownListRenderer",
	                  list       : agentList, //key-value Object 로 구성된 리스트
	                  keyField   : "agentId", // key 에 해당되는 필드명
	                  valueField : "agentName" // value 에 해당되는 필드명
	              }*/
	            } ,
              {dataField : "assigned", headerText : '<spring:message code="sal.title.text.assigned" />', width : '7%'  , editable       : false, visible : false     } ,
              {dataField : "sensitiveFg", headerText : '<spring:message code="sal.title.text.sensitive" />', width : '5%'   ,editable       : false    },
              {dataField : "rem", headerText : '<spring:message code="sal.title.text.sensitiveRem" />', width : '10%'   ,editable       : false    },
              {dataField : "etrFg", headerText : '<spring:message code="sal.title.text.etr" />', width : '5%'   ,editable       : false    },
              {dataField : "etrRem", headerText : '<spring:message code="sal.title.text.otrRem" />', width : '10%'   ,editable       : false    }
              ];

        var excelColLayout = [
              {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : 80 , editable       : false   },
              {dataField : "custId", headerText : '<spring:message code="sal.title.text.customerBrId" />', width : 80 , editable       : false       },
              {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : 150 , editable       : false   ,style :"my-left-style"     },
              {dataField : "corpTypeId", headerText : '<spring:message code="sal.title.text.companyBrType" />', width : 100, 	  editable       : true
                  , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                      var retStr = value;
                      for(var i=0,len=companyList.length; i<len; i++) {
                          if(companyList[i]["codeId"] == value) {
                              retStr = companyList[i]["codeName"];
                              break;
                          }
                      }
                                  return retStr;
	              }
	            , editRenderer : {
	                  type       : "DropDownListRenderer",
	                  list       : companyList, //key-value Object 로 구성된 리스트
	                  keyField   : "codeId", // key 에 해당되는 필드명
	                  valueField : "codeName" // value 에 해당되는 필드명
	              }
              },
              {dataField : "race", headerText : '<spring:message code="sal.text.race" />', width : '10%',       editable       : false},
              {dataField : "colctTrget", headerText : '<spring:message code="sal.title.text.openOsBrTarget" />', width : 80  , editable       : false,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "rentAmt", headerText : '<spring:message code="sal.title.text.currBrOs" />', width : 75  , editable       : false ,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "openMthAging", headerText : '<spring:message code="sal.title.text.openAgingBrMonth" />', width : 95  , editable       : false      } ,
              {dataField : "unBillAmt", headerText : '<spring:message code="sal.text.unbillAmount" />', width : 125  , editable       : false      } ,
              {dataField : "oriPrevAgentId", headerText : '<spring:message code="sal.title.text.prevCaller" />', width : 150    ,    editable       : false } ,
	          /*{dataField : "prevAgentId", headerText : '<spring:message code="sal.title.text.callerId" />', width : 90    ,      editable       : false},
	          */
              {dataField : "agentId", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : 150    ,     editable       : true ,  style:"aui-grid-drop-list-ul"
                  , labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                      var retStr = '';
                      for(var i=0,len=agentList.length; i<len; i++) {
                          if(agentList[i]["agentId"] == value) {
                              retStr = agentList[i]["agentName"];
                              break;
                          }
                      }
                                  return retStr;
	              }
	            , editRenderer : {
	                  type       : "DropDownListRenderer",
	                  list       : agentList, //key-value Object 로 구성된 리스트
	                  keyField   : "agentId", // key 에 해당되는 필드명
	                  valueField : "agentName" // value 에 해당되는 필드명
	              }
	           } ,
              {dataField : "updAgentDt", headerText : '<spring:message code="sal.title.text.assignedDt" />', width : 100  , editable       : false     } ,
              {dataField : "assigned", headerText : '<spring:message code="sal.title.text.assigned" />', width : 70  , editable       : false, visible : false} ,
              {dataField : "sensitiveFg", headerText : '<spring:message code="sal.title.text.sensitive" />', width : 70   ,editable       : false    },
              {dataField : "rem", headerText : '<spring:message code="sal.title.text.sensitiveRem" />', width : 200   ,editable       : false  ,style :"my-left-style"  },
              {dataField : "etrFg", headerText : '<spring:message code="sal.title.text.etr" />', width : 70   ,editable       : false    },
              {dataField : "etrRem", headerText : '<spring:message code="sal.title.text.otrRem" />', width : 300   ,editable       : false    }
              ];


        var assignOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             };

        assignGrid = GridCommon.createAUIGrid("#assignGrid", assignColLayout, "", assignOptions);
        excelGrid = GridCommon.createAUIGrid("#excelGrid", excelColLayout, "", assignOptions);

      /*   // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellDoubleClick", function(event){

              $("#trnsitId").val(AUIGrid.getCellValue(recvGridID , event.rowIndex , "trnsitId"));

              Common.popupDiv("/sales/trBookRecv/trBookRecvViewPop.do",$("#listSForm").serializeJSON(), null, true, "trBookRecvViewPop");

         });*/

         //셀 클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellClick", function(event){
              $("#orderNo").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdNo"));
              $("#salesOrdId").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdId"));
         });


        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(assignGrid, "cellEditBegin", auiCellEditignHandler);
        AUIGrid.setFixedColumnCount(assignGrid, 4);
}

//AUIGrid 메소드
function auiCellEditignHandler(event)
{
    if(event.type == "cellEditBegin")
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);

        if(event.dataField == "corpTypeId")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.getCellValue(assignGrid, event.rowIndex, "typeId")=='965'){  //추가된 Row
                return true;
            } else {
                return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
            }
        }
    }
}

 //리스트 조회.
function fn_selectListAjax() {

    // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    AUIGrid.forceEditingComplete(assignGrid, null, false);

	 if($("#rentalStatus").val() == ""){
	        Common.alert('<spring:message code="sal.alert.msg.plzSelRentalStus" />');
	        return ;
	 }

	if($("#customerType").val() == "964"){
          $("#companyType").val("");
    }

	$("#appType").prop("disabled", false);
    Common.ajax("GET", "/sales/rcms/selectAssignAgentList", $("#searchForm").serialize(), function(result) {

       console.log("성공.");
       console.log( result);

      AUIGrid.setGridData(assignGrid, result);
      AUIGrid.setGridData(excelGrid, result);

      $("#orderNo").val("");
      $("#salesOrdId").val("");
      $("#appType").prop("disabled", true);

  });
}

function fn_clear(){
    $("#searchForm")[0].reset();
}

//리스트 조회.
function fn_save() {

    var editedRowItems = AUIGrid.getEditedRowItems(assignGrid);

    if(editedRowItems.length <= 0) {
        Common.alert('<spring:message code="sal.alert.msg.noUpdateItem" />');
        return ;
    }
    console.log(editedRowItems);
    var param = GridCommon.getEditData(assignGrid);

    Common.ajax("POST", "/sales/rcms/saveAssignAgent", param, function(result) {

    	fn_selectListAjax();

  });
}

function fn_customerChng(){

	if($("#customerType").val() == "964"){
        $("#companyType").multipleSelect("disable");
	}else{
        $("#companyType").multipleSelect("enable");
	}

}

function fn_uploadPop(){
	Common.popupDiv("/sales/rcms/uploadAssignAgentPop.do",null, fn_selectListAjax, true, "uploadAssignAgentPop");
}

function fn_edit(){

	if($("#salesOrdId").val() == ""){
		Common.alert("Please select data to edit. ");
		return;
	}
	//Common.popupDiv("/sales/rcms/updateRemarkPop.do",null, fn_selectListAjax, true, "updateRemarkPop");
	Common.popupDiv("/sales/rcms/updateRemarkPop.do",null, '', true, "updateRemarkPop");
}

/* Report */
function fn_badAccReport(){
	Common.popupDiv("/sales/rcms/badAccReportPop.do",null, null , true, "badReportPop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.rcmsAssignAgent" /></h2>

<ul class="right_btns">
    <%-- <li><p class="btn_blue"><a href="#"  id="btnUpload" onclick="javascript:fn_uploadPop();"></span><spring:message code="sal.title.text.uploadAssign" /></a></p></li> --%>
    <li><p class="btn_blue"><a href="#" id="btnSave" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnClear" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="editForm" name="editForm" action="#" method="post">
    <input type="hidden" id="orderNo" name="orderNo" />
    <input type="hidden" id="salesOrdId" name="salesOrdId" />
</form>
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rcmsAppType" /><span class="must">*</span></th>
        <td>
        <select id="appType" name="appType" class="w100p disabled" disabled="disabled" >
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.ordStus" /><span class="must">*</span></th>
        <td>
          <select  id="orderStatus" name="orderStatus" class="w100p"></select>
        </td>
        <th scope="row"><spring:message code="sal.text.rentalStatus" /><span class="must">*</span></th>
        <td>
        <select id="rentalStatus" name="rentalStatus" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custType" /><span class="must">*</span></th>
        <td>
          <select  id="customerType" name="customerType" class="w100p" onchange="javascript:fn_customerChng();"></select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
        <td>
        <select id="companyType" name="companyType" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.openAgingBrMth" /></th>
        <td>
        <select id="openMonth" name="openMonth" class="multy_select w100p" multiple="multiple">
        </select>
        <!--
        <input type="text" title="DOB" id="_dob" name="dob" placeholder="DD/MM/YYYY" class="j_date" /> -->
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
        <td>
        <select id="rosCaller" name="rosCaller" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.ordNop" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="orderNo" name="orderNo"/>
        </td>
        <th scope="row">Over 60 months</th>
        <td>
        <input type="checkbox" id="over60" name="over60"  value="Y"/>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.customerId" /></th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="customerId" name="customerId" />
        </td>
        <th scope="row"><spring:message code="sal.text.race"/></th>
        <td>
            <select id="cmbRaceId" name="raceId" class="multy_select w100p"  multiple="multiple" ></select>
        </td>
        <th scope="row"></th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.assigned" /></th>
        <td>
        <input type="checkbox" id="assignYn" name="assignYn"  value="Y"/>
        </td>
        <th scope="row"><spring:message code="sal.title.text.sensitive" /></th>
        <td>
        <p><select id="sensitiveYn" name="sensitiveYn" class="w100p"></select></p>
        </td>
        <th scope="row"><spring:message code="sal.title.text.etr" /></th>
        <td>
        <p><select id="etrYn" name="etrYn" class="w100p"></select></p>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn type2"><a onclick="javascript: fn_badAccReport()"><spring:message code="sal.title.text.badaccRaw" /></a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns mt10">
    <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="sal.title.text.download" /></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_edit();"><spring:message code="sal.title.text.edit" /></a></p></li>
    <%-- <li><p class="btn_grid"><a href="#" onclick="javascript:fn_save();"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="assignGrid" style="width:100%; height:300px; margin:0 auto;"></div>
    <div id="excelGrid" style="width:100%; height:300px; margin:0 auto; display: none" ></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
