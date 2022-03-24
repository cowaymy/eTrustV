<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<%--

 --%>
<script type="text/javaScript" language="javascript">

	var listMyGridID;
	var MEM_TYPE     = '${SESSION_INFO.userTypeId}';

	var _option = {
	    width : "1200px",
	    height : "800px"
	};

	$(document).ready(function(){
        createAUIGrid();
        if("${SESSION_INFO.userTypeId}" == "2" ){

            if("${SESSION_INFO.memberLevel}" =="3" || "${SESSION_INFO.memberLevel}" =="4"){
                $("#btnReq").hide();
            }
        }

        AUIGrid.bind(listMyGridID, "cellDoubleClick", function(event) {
          //  Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
        	 fn_setDetail(listMyGridID, event.rowIndex);
        });

        doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'LOAN_PROD'}, '', 'listProductId', 'S', 'fn_setOptGrpClass');//product

        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listKeyinBrnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', ' - ', '',   'listDscBrnchId', 'M', 'fn_multiCombo'); //Branch Code

       /*  doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 5, parmDisab : 0}, '', 'listRentStus', 'M', 'fn_multiCombo'); */
    });

	function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text");
	}

    function fn_setDetail(gridID, rowIdx){
        //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
        Common.popupDiv("/services/onLoanOrder/onLoanOrdDtlPop.do", { loanOrdId : AUIGrid.getCellValue(gridID, rowIdx, "loanOrdId"),  salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId")}, null, true, "_divIdLoanOrdDtl");
    }

    function fn_selectListAjax() {

        Common.ajax("GET", "/services/onLoanOrder/selectOnLoanJsonList", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });

    }

    $(function(){
    	$('#btnNew').click(function() {
            Common.popupDiv("/services/onLoanOrder/onLoanOrderRegPop.do");
        });

    	$('#btnCancel').click(function() {
    		fn_cancelReqPop();
        });

    	$('#btnSrch').click(function() {
            if(fn_validSearchList()) fn_selectListAjax();
        });

    	$('#btnClear').click(function() {
            $('#listSearchForm').clearForm();
        });

    	$('#btnExport').click(function() {

            var grdLength = "0";
            grdLength = AUIGrid.getGridData(listMyGridID).length;

            if(Number(grdLength) > 0){
                GridCommon.exportTo("#list_grid_wrap", "xlsx", "OnLoanOrderSearchResultList");

            }else{
                Common.alert('* <spring:message code="sal.alert.msg.noExport" />');
            }

        });
    });

    function fn_validSearchList() {
        var isValid = true, msg = "";

        if(FormUtil.isEmpty($('#listOrdNo').val())
        && FormUtil.isEmpty($('#listCustId').val())
        && FormUtil.isEmpty($('#listCustName').val())
        && FormUtil.isEmpty($('#listCustIc').val())
        && FormUtil.isEmpty($('#listSalesmanCode').val())
        && FormUtil.isEmpty($('#listPoNo').val())
        && FormUtil.isEmpty($('#listContactNo').val())
        && FormUtil.isEmpty($('#listSerialNo').val())
        && FormUtil.isEmpty($('#listSirimNo').val())
        && FormUtil.isEmpty($('#listCrtUserId').val())
        && FormUtil.isEmpty($('#listRefNo').val())
        ) {

            if(FormUtil.isEmpty($('#listLoanOrdStartDt').val()) || FormUtil.isEmpty($('#listLoanOrdEndDt').val())) {
                isValid = false;
                msg += '* Please select Loan Date.';
            }
            /* else {
                var diffDay = fn_diffDate($('#listLoanOrdStartDt').val(), $('#listLoanOrdEndDt').val());

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
        //{ headerText : "<spring:message code='sales.OrderNo'/>", dataField : "ordNo",       editable : false, width : 80  }
          { headerText : "<spring:message code='service.grid.LoanNo'/>", dataField : "loanNo",       editable : false, width : 100  }
          , { headerText : "<spring:message code='service.grid.LoanStatus'/>",  dataField : "loanStusCode", editable : false, width : 80  }
          , { headerText : "<spring:message code='service.grid.LoanDate'/>",   dataField : "loanDt",       editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.refNo2'/>",  dataField : "refNo",       editable : false, width : 80  }
          , { headerText : "<spring:message code='service.grid.InstallNo'/>",  dataField : "installNo",       editable : false, width : 80  }
          , { headerText : "<spring:message code='sales.prod'/>",    dataField : "productName", editable : false, width : 150 }
          , { headerText : "<spring:message code='sales.prod'/>",    dataField : "productName", editable : false, width : 150 }
          , { headerText : "<spring:message code='sales.custId'/>",  dataField : "custId",      editable : false, width : 70  }
          , { headerText : "<spring:message code='sales.cusName'/>", dataField : "custName",    editable : false}
          , { headerText : "<spring:message code='sales.NRIC2'/>",   dataField : "custIc",      editable : false, width : 100 }
          , { headerText : "<spring:message code='sales.Creator'/>", dataField : "crtUserId",   editable : false, width : 100 }
          , { headerText : "ordId",                                  dataField : "ordId",       visible  : false }
          , { headerText : "loanOrdId",                                  dataField : "loanOrdId",       visible  : false }
          , { headerText : "salesmanCode",                                  dataField : "salesmanCode",       visible  : false }
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

    function fn_multiCombo(){
        $('#listKeyinBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listDscBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listOrdStusId').multipleSelect("checkAll");
    }

    function fn_report() { // for report overview  use. *crystal report
        var option = {
            isProcedure : false
        };
        Common.report("dataForm2", option);
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

    function fn_cancelReqPop() {
        var selIdx = AUIGrid.getSelectedIndex(listMyGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/services/onLoanOrder/cancelReqPop.do", {loanOrdId: AUIGrid.getCellValue(listMyGridID, selIdx, "loanOrdId"),  salesOrderId : AUIGrid.getCellValue(listMyGridID, selIdx, "ordId") }, null , true);
        }
        else {
            Common.alert('<spring:message code="sal.alert.msg.ordMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noOrdSel" /></b>');
        }
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
	    <%-- <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li><spring:message code='sales.path.sales'/></li>
	    <li><spring:message code='sales.path.order'/></li> --%>
	</ul>

	<aside class="title_line"><!-- title_line start -->
	   <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	   <h2><spring:message code='service.title.onLoan'/></h2>
	   <ul class="right_btns">
	       <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		    <li><p class="btn_blue"><a id="btnNew" href="#" ><spring:message code='sales.btn.new'/></a></p></li>
		  </c:if>
		  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_blue"><a id="btnCancel" href="#" ><spring:message code='sys.btn.cancel'/></a></p></li>
          </c:if>
	       <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
	   </ul>
	</aside><!-- title_line end -->

	<form id="listSearchForm" name="listSearchForm" action="#" method="post">
	    <input id="listLoanOrdId" name="loanOrdId" type="hidden" />

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
	   <th scope="row"><spring:message code='service.grid.LoanNo'/></th>
        <td>
        <input id="listLoanNo" name="loanNo" type="text" title="Loan No" placeholder="<spring:message code='service.grid.LoanNo'/>" class="w100p" />
        </td>
	    <th scope="row"><spring:message code='service.grid.InstallNo'/></th>
	    <td>
	    <input id="listInstallNo" name="installNo" type="text" title="Install No" placeholder="<spring:message code='service.grid.InstallNo'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='service.grid.LoanDate'/></th>
	    <td>
	    <div class="date_set w100p"><!-- date_set start -->
	    <p><input id="listLoanOrdStartDt" name="loanOrdStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    <span>To</span>
	    <p><input id="listLoanOrdEndDt" name="loanOrdEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    </div><!-- date_set end -->
	    </td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='service.grid.LoanStatus'/></th>
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
	    <th scope="row"><spring:message code='sales.dscBranch'/></th>
	    <td>
	    <select id="listDscBrnchId" name="dscBrnchId" class="multy_select w100p" multiple="multiple"></select>
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
	    <th scope="row"><spring:message code='sales.prod'/></th>
	    <td>
	    <select id="listProductId" name="productId" class="w100p"></select>
	    </td>
	    <th scope="row"><spring:message code='sales.salesman'/></th>
	    <td>
	    <input id="listSalesmanCode" name="salesmanCode" type="text" title="Salesman" placeholder="<spring:message code='sales.salesman'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='sales.Creator'/></th>
        <td>
        <input id="listCrtUserId" name="crtUserId" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
        </td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='sales.refNo3'/></th>
	    <td>
	    <input id="listRefNo" name="refNo" type="text" title="Reference No<" placeholder="<spring:message code='sales.refNo3'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='sales.poNum'/></th>
	    <td>
	    <input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='sales.ContactNo'/></th>
	    <td>
	    <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
	    </td>
	</tr>
	<tr>
	    <th scope="row"><spring:message code='sales.vaNum'/></th>
	    <td>
	    <input id="listVaNo" name="vaNo" type="text" title="VA Number" placeholder="<spring:message code='sales.vaNum'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='sales.SeriacNo'/></th>
	    <td>
	    <input id="listSerialNo" name="serialNo" type="text" title="Serial Number" placeholder="<spring:message code='sales.SeriacNo'/>" class="w100p" />
	    </td>
	    <th scope="row"><spring:message code='sales.SirimNo'/></th>
	    <td>
	    <input id="listSirimNo" name="sirimNo" type="text" title="Sirim Number" placeholder="<spring:message code='sales.SirimNo'/>" class="w100p" />
	    </td>
	</tr>
	</tbody>
	</table><!-- table end -->

	</form>

	<section class="search_result"><!-- search_result start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->

	</section><!-- search_result end -->
</section> <!-- content end -->