<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
//AUIGrid 생성 후 반환 ID
var listMyGridID;
var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';
var MEM_TYPE     = '${SESSION_INFO.userTypeId}';
var salesmanCode = '${SESSION_INFO.userName}';

var _option = {
    width : "1200px", // 창 가로 크기
    height : "800px" // 창 세로 크기
};

$(document).ready(function(){
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {
        if(IS_3RD_PARTY == '0') {
            fn_setDetail(listMyGridID, event.rowIndex);
        }
        else {
            Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
        }
    });


    console.log("SalesmanCode: " + '${SESSION_INFO.userId}');

    //if($("#memType").val() == 1 || $("#memType").val() == 2){
        if("${SESSION_INFO.memberLevel}" =="1"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="2"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="3"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="4"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

            $("#memCode").val("${memCode}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");

            $("#listSalesmanCode").val(salesmanCode);
            $("#listSalesmanCode").attr("readonly", true);
        }
 //   }


    if(IS_3RD_PARTY == '0') {
        doGetComboOrder('/homecare/sales/selectCodeList.do', '10', 'CODE_ID',  '' , 'listAppType', 'M', 'fn_multiCombo2'); //Common Code

    }
/*      else {
        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '66', 'listAppType',  'S'); //Common Code
    } */

    //doGetCombo('/common/selectCodeList.do',       '10', '',   'listAppType', 'M', 'fn_multiCombo'); //Common Code
    //doGetComboAndGroup2('/homecare/sales/selectProductCodeList.do', '', '', 'listProductId', 'S', '');//product 생성


    doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
    //doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code

    //doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 5, parmDisab : 0}, '', 'listRentStus', 'M', 'fn_multiCombo');
});

function fn_setDetail(gridID, rowIdx){
    //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
    Common.popupDiv("/homecare/sales/htOrderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
}

  function fn_selectListAjax() {

    //if(IS_3RD_PARTY == '1') $("#listAppType").removeAttr("disabled");
console.log($("#listSearchForm").serialize());
    Common.ajax("GET", "/homecare/sales/selectHTOrderJsonList", $("#listSearchForm").serialize(), function(result) {
        AUIGrid.setGridData(listMyGridID, result);
    });

    //if(IS_3RD_PARTY == '1') $("#listAppType").prop("disabled", true);
}

  $(function(){

	  $('#btnNew').click(function() {
          Common.popupDiv("/homecare/sales/htOrderRegisterPop.do?pageAuth=${PAGE_AUTH.funcUserDefine5}");
      });
	  $('#btnEdit').click(function() {
          fn_orderModifyPop();
      });
	  /* $('#btnReq').click(function() {
          fn_orderRequestPop();
      }); */
      $('#btnCancel').click(function() {
      fn_orderCancelRequestPop();
      });
      $('#btnSrch').click(function() {
          if(fn_validSearchList()) fn_selectListAjax();
      });
      $('#btnClear').click(function() {
          $('#listSearchForm').clearForm();
      });
      $('#btnSof').click(function() {
    	    Common.popupDiv("/homecare/sales/htOrderSOFListPop.do", null, null, true);
      });
      $('#btnRaw').click(function() {
          Common.popupDiv("/homecare/sales/htRawDataPop.do", null, null, true);
      });
      $("#btnPayList").click(function() {
          Common.popupDiv("/homecare/sales/htOrderPaymentListingPop.do", '', null, null, true);
      });
  });

function fn_validSearchList() {
    var isValid = true, msg = "";

    if(FormUtil.isEmpty($('#listOrdNo').val())
    && FormUtil.isEmpty($('#listCustId').val())
    && FormUtil.isEmpty($('#listCustName').val())
    && FormUtil.isEmpty($('#listCustIc').val())
    //&& FormUtil.isEmpty($('#listVaNo').val())
    && FormUtil.isEmpty($('#listSalesmanCode').val())
    && FormUtil.isEmpty($('#listPoNo').val())
    && FormUtil.isEmpty($('#listContactNo').val())
    //&& FormUtil.isEmpty($('#listSerialNo').val())
    //&& FormUtil.isEmpty($('#listSirimNo').val())
    //&& FormUtil.isEmpty($('#listRelatedNo').val())
    && FormUtil.isEmpty($('#listCrtUserId').val())
    && FormUtil.isEmpty($('#listPromoCode').val())
    && FormUtil.isEmpty($('#listRefNo').val())
    ) {

        if(FormUtil.isEmpty($('#listOrdStartDt').val()) || FormUtil.isEmpty($('#listOrdEndDt').val())) {
            isValid = false;
            msg += '* <spring:message code="sal.alert.msg.selOrdDt" /><br/>';
        }
  /*       else {
            var diffDay = fn_diffDate($('#listOrdStartDt').val(), $('#listOrdEndDt').val());

            if(diffDay > 31 || diffDay < 0) {
                isValid = false;
                msg += '* <spring:message code="sal.alert.msg.srchPeriodDt" />';
            }
        } */
    }

    if(!isValid) Common.alert('<spring:message code="sal.title.text.ordSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

    return isValid;
}

function fn_diffDate(startDt, endDt) {
    var arrDt1 = startDt.split("/");
    var arrDt2 = endDt.split("/");

    var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
    var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

    var diff = dt2 - dt1;
    var day = 1000*60*60*24;

    return (diff/day);
}


function createAUIGrid() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
        { headerText : "Service Order No",                                dataField : "ordNo",       editable : false, width : 150 }
      , { headerText : "<spring:message code='sales.Status'/>",  dataField : "ordStusCode", editable : false, width : 80  }
      , { headerText : "<spring:message code='sales.AppType'/>", dataField : "appTypeCode", editable : false, width : 80  }
      , { headerText : "Srv Type",                                          dataField : "serviceType", editable : false, width : 80  }
      , { headerText : "<spring:message code='sales.ordDt'/>",   dataField : "ordDt",       editable : false, width : 100 }
      , { headerText : "<spring:message code='sales.refNo2'/>",  dataField : "refNo",       editable : false, width : 200  }
      , { headerText : "Adjustment Note",  dataField : "adjnote",       editable : false, width : 200  }
      , { headerText : "Product Size",    dataField : "productName", editable : false, width : 150 }
      , { headerText : "Brand",                                               dataField : "brand", editable : false, width : 150 }
      , { headerText : "<spring:message code='sales.custId'/>",  dataField : "custId",      editable : false, width : 80  }
      , { headerText : "<spring:message code='sales.cusName'/>", dataField : "custName",    editable : false, width : 300 }
      , { headerText : "<spring:message code='sales.NRIC2'/>",   dataField : "custIc",      editable : false, width : 150 }
      , { headerText : "<spring:message code='sales.salesman'/>", dataField : "salesmanCode",   editable : false, width : 80 }
      , { headerText : "<spring:message code='sales.Creator'/>", dataField : "crtUserId",   editable : false, width : 80 }
      , { headerText : "<spring:message code='sales.pvYear'/>",  dataField : "pvYear",      editable : false, width : 60  }
      , { headerText : "<spring:message code='sales.pvMth'/>",   dataField : "pvMonth",     editable : false, width : 60  }
      , { headerText : "ordId",                                                dataField : "ordId",       visible  : false }
        ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 1,
        showStateColumn     : false,
        displayTreeOpen     : false,
      //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };

    listMyGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
}

/* function fn_orderRequestPop() {
    var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
    if(selIdx > -1) {
        Common.popupDiv("/homecare/sales/htOrderReqCancellationPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
    }
    else {
        Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
    }
}*/

function fn_orderModifyPop() {
    var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
    if(selIdx > -1) {
        Common.popupDiv("/homecare/sales/htOrderModifyPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
    }
    else {
        Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
    }
}

function fn_orderCancelRequestPop() {
    var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
    var clickChk = AUIGrid.getSelectedItems(listMyGridID);
    if(selIdx > -1) {
    	if(clickChk[0].item.appTypeCode == "FT1T" || clickChk[0].item.appTypeCode == "FT1Y"){
    		if(clickChk[0].item.ordStusCode == "ACT" || clickChk[0].item.ordStusCode == "COM"){
        Common.popupDiv("/homecare/sales/htOrderCancelRequestPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
    	  }else{
    		  Common.alert("CS Cancel request disallow.");
    	  }
    	}
    	else if (clickChk[0].item.appTypeCode == "CS1T" || clickChk[0].item.appTypeCode == "CS1Y"){
    		if(clickChk[0].item.adjnote ==  "" || clickChk[0].item.adjnote ==  null) {
    			Common.alert("CS Cancel request disallow due to CS No. not yet created Credit Note. </br> Kindly inform Homecare Dept to create CN and approved by Finance Dept to proceed CS Cancellation.");
    		}else{
    	        Common.popupDiv("/homecare/sales/htOrderCancelRequestPop.do", { salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
    		}

    	}else{
    		  Common.alert("CS Cancel request disallow.");
    	  }
    	}
    else {
        Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
    }
}



function fn_multiCombo(){
    $('#listKeyinBrnchId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });

    $('#listOrdStusId').multipleSelect("checkAll");
    $('#listPackId').multipleSelect("checkAll");

}

function fn_multiCombo2(){
    $('#listAppType').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#listAppType').multipleSelect("checkAll");
}

function fn_multiCombo3(){
    $('#listProductId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#listProductId').multipleSelect("checkAll");

    $('#unitTypeId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#unitTypeId').multipleSelect("checkAll");
}

function fn_getProductSize(){

	var serviceType = "";
	var unitTypeMasterId;
	if ($("#ServiceTypeId").val() == '6861'){
		serviceType = '447';
	}else if ($("#ServiceTypeId").val() == '6862'){
		serviceType = '521';
		unitTypeMasterId = '520';
	}else if ($("#ServiceTypeId").val() == '6863'){
        serviceType = '515';
    }

	doGetComboData('/common/selectProductSizeList.do', { groupCode : serviceType }, '', 'listProductId', 'M','fn_multiCombo3');
	doGetComboData('/common/selectUnitTypeList.do', { groupCode : unitTypeMasterId }, '', 'unitTypeId', 'M','fn_multiCombo3');
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
    });
};


function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("list_grid_wrap", "xlsx", "Care Service Order");
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Homecare</li>
    <li>Sales</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Care Service Order</h2>
<ul class="right_btns">
<c:if test="${SESSION_INFO.userIsExternal == '0'}">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
 <li><p class="btn_blue"><a id="btnNew" href="#" ><spring:message code='sales.btn.new'/></a></p></li>
  <li><p class="btn_blue"><a id="btnEdit" href="#"><spring:message code='sales.btn.edit'/></a></p></li>
  </c:if>
</c:if>

<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
 <li><p class="btn_blue"><a id="btnCancel" href="#" ><spring:message code='sal.title.text.cancelReq'/></a></p></li>
  </c:if>

    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.Search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<!-- Ledger Form -->
<form id="_frmLedger" name="frmLedger" action="#" method="post">
    <input id="_ordId" name="ordId" type="hidden" value="" />
</form>

<form id="listSearchForm" name="listSearchForm" action="#" method="post">
    <input id="listSalesOrderId" name="salesOrderId" type="hidden" />
        <input type="hidden" name="memType" id="memType" value="${memType }"/>
    <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }"/>
    <input type="hidden" name="memCode" id="memCode" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Service Order No.</th>
    <td>
    <input id="listOrdNo" name="ordNo" type="text" title="Order No" placeholder="<spring:message code='sales.OrderNo'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.AppType2'/></th>
    <td>
<c:if test="${SESSION_INFO.userIsExternal == '0'}">
    <select id="listAppType" name="appType" class="multy_select w100p" multiple="multiple"></select>
</c:if>
<%-- <c:if test="${SESSION_INFO.userIsExternal == '1'}">
    <!-- <select id="listAppType" name="appType" class="w100p" disabled></select> -->
       <select id="listAppType" name="appType">
        <option value="3212">Care Service</option>
        <option value="145">Free Trial</option>
        </select>
</c:if> --%>
    </td>
    <th scope="row"><spring:message code='sales.ordDt'/></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="listOrdStartDt" name="ordStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="listOrdEndDt" name="ordEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.ordStus'/></th>
    <td>
    <select id="listOrdStusId" name="ordStusId" class="multy_select w100p" multiple="multiple">
        <option value="1">Active</option>
        <option value="4">Completed</option>
        <option value="10">Cancelled</option>
    </select>
    </td>

    <th scope="row"><spring:message code='sales.keyInBranch'/></th>
    <td>
    <select id="listKeyinBrnchId" name="keyinBrnchId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.Creator'/></th>
    <td>
    <input id="listCrtUserId" name="crtUserId" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.custId2'/></th>
    <td>
    <input id="listCustId" name="custId" type="text" title="<spring:message code='sales.custId2'/>" placeholder="Customer ID (Number Only)" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.cusName'/></th>
    <td>
    <input id="listCustName" name="custName" type="text" title="Customer Name" placeholder="<spring:message code='sales.cusName'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.NRIC2'/></th>
    <td>
    <input id="listCustIc" name="custIc" type="text" title="NRIC/Company No" placeholder="<spring:message code='sales.NRIC2'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Service Type</th>
    <td>
    <select id="ServiceTypeId" name="ServiceTypeId" class="w100p" onchange = "fn_getProductSize()" >
        <option value="">Choose One</option>
        <option value="6862">Air-Conditioning</option>
        <option value="6861">Mattress</option>
        <option value="6863">Massage Chair</option>
        </select>
    </td>
    <th scope="row">Product Size</th>
    <td>
    <select id="listProductId" name="productId" class="multy_select w100p" multiple="multiple">
    </select>
    </td>
    <th scope="row">Unit Type</th>
    <td>
    <select id="unitTypeId" name="unitTypeId" class="multy_select w100p" multiple="multiple">
    </select>
    </td>
</tr>
<tr>

    <th scope="row"><spring:message code='sales.salesman'/></th>
    <td>
    <input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="<spring:message code='sales.salesman'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.refNo3'/></th>
    <td>
    <input id="listRefNo" name="refNo" type="text" title="Reference No<" placeholder="<spring:message code='sales.refNo3'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.ContactNo'/></th>
    <td>
    <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
    </td>

</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.orgCode" /></th>
    <td>
    <input type="text" title="" id="orgCode" name="orgCode" value="${orgCode }" placeholder="Organization Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
    <td>
    <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.deptCode" /></th>
    <td>
    <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.poNum'/></th>
    <td>
    <input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.promoCd'/></th>
    <td>
    <input id="listPromoCode" name="promoCode" type="text" title="Promotion Code" placeholder="<spring:message code='sales.promoCd'/>" class="w100p" />
    </td>

</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"><spring:message code='sales.msg.ordlist.keyin'/></span></th>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" id="btnSof">Mattress Care Service (MCS) List</a></p></li>
        <li><p class="link_btn type2"><a href="#" id="btnRaw">Care Service (SALES) Raw Data</a></p></li>
        <li><p class="link_btn type2"><a href="#" id="btnPayList">Mattress Care Service (MCS) Payment Listing</a></p></li>
      </c:if>
    </ul>

    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->


</form>

</section><!-- search_table end -->
<ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_grid"><a href="javascript:void(0);" onclick="fn_excelDown()">Generate</a></p></li>
     </c:if>
</ul>
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
