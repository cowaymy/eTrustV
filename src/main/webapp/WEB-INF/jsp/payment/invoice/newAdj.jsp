<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

    var myGridID;

    //Default Combo Data
    var adjTypeData = [{"codeId": "1293","codeName": "Credit Note"},{"codeId": "1294","codeName": "Debit Note"}];

    //Grid Properties 설정
    var gridPros = {
        editable : true,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
    };

    var columnLayout=[
        { dataField:"txinvoiceitemid" ,headerText:"<spring:message code='pay.head.taxInvoiceItemId'/>" ,editable : false, visible:false },
        { dataField:"txinvoiceitemtypeid" ,headerText:"<spring:message code='pay.head.taxInvoiceTypeId'/>" ,editable : false, visible:false },
        { dataField:"billitemtaxcodeid" ,headerText:"<spring:message code='pay.head.billItemTaxCodeId'/>" ,editable : false, visible:false },
        { dataField:"billitemtype" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false ,width : 120},
        { dataField:"billitemrefno" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false ,width : 120 },
        { dataField:"billitemunitprice" ,headerText:"<spring:message code='pay.head.unitPrice'/>" ,editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        { dataField:"billitemqty" ,headerText:"<spring:message code='pay.head.quantity'/>" ,editable : false ,width : 120},
        { dataField:"billitemtaxrate" ,headerText:"<spring:message code='pay.head.gstRate'/>" ,editable : false , postfix : "%" ,width : 120},
        { dataField:"billitemcharges" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        { dataField:"billitemtaxes" ,headerText:"<spring:message code='pay.head.gstRate'/>" ,editable : false , dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        { dataField:"billitemamount" ,headerText:"<spring:message code='pay.head.total'/>" ,editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        {
            dataField : "totamount",
            headerText : "<spring:message code='pay.head.totalAdjustmentAmount'/>",
            dataType : "numeric",
            width : 220,
            formatString : "#,##0.00",
            style : "input_style",
            editRenderer : {
                type : "InputEditRenderer",
                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                onlyNumeric : true, // 0~9만 입력가능
                allowPoint : true, // 소수점( . ) 도 허용할지 여부
                allowNegative : false, // 마이너스 부호(-) 허용 여부
                textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                autoThousandSeparator : true // 천단위 구분자 삽입 여부
            }
        }];

    // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){

        //Adjustment Type 생성
        doDefCombo(adjTypeData, '' ,'adjType', 'S', '');

        //Adjustment Type 변경시 Reason Combo 생성
        $('#adjType').change(function (){
            $("#adjReason option").remove();

            if($(this).val() != ""){
                var param = $(this).val() == "1293" ? "1584" : "1585";
                doGetCombo('/common/selectAdjReasontList.do', param , ''   , 'adjReason' , 'S', '');
            }
        });

        //그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

        //Cell Edit Event : adjustment 금액은 total amount를 초과할수 없음.
        AUIGrid.bind(myGridID, "cellEditEnd", function( event ) {
            var charge = AUIGrid.getCellValue(myGridID, event.rowIndex, "billitemamount"); //invoice charge
            var totamount = AUIGrid.getCellValue(myGridID, event.rowIndex, "totamount"); //transfer amount

            if(charge < totamount){
                AUIGrid.setCellValue(myGridID, event.rowIndex, 'totamount', charge);
            }

            //그리드에서 수정된 총 금액 계산
            auiGridSelectionChangeHandler(event);
        });

        //초기화면 로딩시 조회
        $("#invoiceNo").val("${refNo}");
        confirmList();
    });

    function getAdjustmentInfo(refNo){

        //데이터 조회 (초기화면시 로딩시 조회)
        Common.ajax("GET", "/payment/selectNewAdjList.do", {"refNo":refNo}, function(result) {
            if(result != 'undefined'){
                $("#reselect").attr("disabled", true);
                $("#invoiceNo").attr("readonly", "readonly");

                //hidden값 셋팅
                $("#hiddenSalesOrderId").val(result.master.ordId);
                $("#hiddenInvoiceType").val(result.master.txinvoicetypeid);
                $("#hiddenAccountConversion").val(result.master.accountconversion);

                //Master데이터 출력
                $("#tInvoiceNo").text(result.master.brNo);
                $("#tInvoiceDt").text(result.master.taxInvcDt);
                $("#tInvoiceType").text(result.master.invoicetype);
                $("#tGroupNo").text(result.master.txinvoicetypeid);
                $("#tOrderNo").text(result.master.ordNo);
                $("#tServiceNo").text(result.master.serviceno);
                $("#CustName").text(result.master.custName);
                $("#tContactPerson").text(result.master.cntcPerson);
                $("#tAddress").text(result.master.address);
                $("#tRemark").text(result.master.rem);
                $("#tOverdue").text(result.master.overdue);
                $("#tTaxes").text(result.master.taxes);
                $("#tDue").text(result.master.amountdue);

                //Detail데이터 출력
                AUIGrid.setGridData(myGridID, result.detail);

                $("#invoiceNo").addClass('readonly');
                $("#invoiceNo").prop('readonly', true);
                $("#confirm").hide();
                $("#search").hide();
                $("#reSelect").show();
            }
        });
    }

    //Total Adjustment Amount 계산
    function auiGridSelectionChangeHandler(event) {
        var allList = AUIGrid.getGridData(myGridID);
        var val;
        var sum = 0;

        if(allList.length < 1) {
            $('#totAdjustment').text("0.00");
            return;
        }

        for(i=0; i<allList.length; i++) {
            val = String(AUIGrid.getCellValue(myGridID, i, "totamount")).replace(",", ""); // 컴마 모두 제거
            val = Number(val);

            if(isNaN(val)) {
                continue;
            }
            sum += val;
        }

        $('#totAdjustment').text(sum);
    }


    //confirm 버튼 클릭
    function confirmList(){
        if(FormUtil.checkReqValue($("#invoiceNo")) ){
            Common.alert("<spring:message code='pay.alert.insertInvoiceNumber'/>");
            return;
        }

        getAdjustmentInfo($("#invoiceNo").val());

    }

    //reselect 버튼 클릭
    function fn_reSelect(){
        $("#confirm").show();
        $("#search").show();
        $("#reSelect").hide();

        $("#invoiceNo").val("");
        $("#invoiceNo").removeClass('readonly');
        $("#invoiceNo").prop('readonly', false);
    }

    //search 버튼 클릭
    function fn_cmmSearchInvoicePop(){
        Common.popupDiv('/payment/common/initCommonSearchInvoicePop.do', null, null , true ,'_searchInvoice');
    }

    //search Invoice 팝업에서 리스트 선택시
    function _callBackInvoicePop(searchInvoicePopGridID,rowIndex, columnIndex, value, item){
        $("#invoiceNo").val(AUIGrid.getCellValue(searchInvoicePopGridID, rowIndex, "taxInvcRefNo"));
        confirmList();
        $('#_searchInvoice').hide();
        $('#_searchInvoice').remove();
    }

    //Save
    function fn_saveAdjustmentInfo(){

    	if(FormUtil.checkReqValue($("#adjType option:selected")) ){
    		Common.alert("<spring:message code='pay.alert.selectAdjType'/>");
            return;
        }

    	if(FormUtil.checkReqValue($("#adjReason option:selected")) ){
    		Common.alert("<spring:message code='pay.alert.selectAdjReason'/>");
            return;
        }

        if(FormUtil.checkReqValue($("#remark")) ){
        	Common.alert("<spring:message code='pay.alert.selectAdjRemark'/>");
            return;
        }

    // Allow User to enter adjustment amount less than 1
  /*       if(Number($("#totAdjustment").text()) < 1){
        	Common.alert("<spring:message code='pay.alert.selectAdjAmt'/>");
        	return;
        }
         */
        //param data array
        var data = GridCommon.getGridData(myGridID);
        data.form = $("#searchForm").serializeJSON();

        //Ajax 호출
        Common.ajax("POST", "/payment/saveNewAdjList.do", data, function(result) {
        	var returnMsg = "<spring:message code='pay.alert.saveBatchNewAdjList' arguments='"+result.data+"' htmlEscape='false'/>";

        	Common.alert(returnMsg, function (){
        		location.href = "/payment/initAdjCnDn.do";

        	});

        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
            } catch (e) {
                console.log(e);
            }
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });

    }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Adjustment Management - New CN/DN Request</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_saveAdjustmentInfo();"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- title_line start -->
        <aside class="title_line">
            <h3>Select Invoice For Adjustment</h3>
        </aside>
        <form name="searchForm" id="searchForm"  method="post">
            <input type="hidden" id="hiddenSalesOrderId" name="hiddenSalesOrderId" />
            <input type="hidden" id="hiddenInvoiceType" name="hiddenInvoiceType" />
            <input type="hidden" id="hiddenAccountConversion" name="hiddenAccountConversion" />

            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Invoice No</th>
                        <td>
                            <input id="invoiceNo" name="invoiceNo" type="text" placeholder="Invoice No." class="w100p" />
                        </td>
                        <td>
                            <p class="btn_sky">
                                <a href="javascript:confirmList();" id="confirm" style="display: none"><spring:message code='pay.btn.confirm'/></a>
                                <a href="javascript:fn_cmmSearchInvoicePop();" id="search" style="display: none"><spring:message code='sys.btn.search'/></a>
                            </p>
                            <p class="btn_sky">
                                <a href="javascript:fn_reSelect();" id="reSelect" style="display: none"><spring:message code='pay.btn.reselect'/></a>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
	        <!-- title_line start -->
	        <aside class="title_line">
	            <h3>Invoice Information</h3>
	        </aside>
	        <table class="type1"><!-- table start -->
	            <caption>table</caption>
	            <colgroup>
	                <col style="width:200px" />
	                <col style="width:*" />
	                <col style="width:200px" />
	                <col style="width:*" />
	                <col style="width:200px" />
	                <col style="width:*" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row">Invoice No</th>
	                    <td id="tInvoiceNo"></td>
	                    <th scope="row">Invoice Date</th>
	                    <td id="tInvoiceDt"></td>
	                    <th scope="row">Invoice Type</th>
	                    <td id="tInvoiceType"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Group No.</th>
	                    <td id="tGroupNo"></td>
	                    <th scope="row">Order No.</th>
	                    <td id="tOrderNo"></td>
	                    <th scope="row">Service No.</th>
	                    <td id="tServiceNo"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Customer Name</th>
	                    <td id="CustName" colspan="5"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Contact Person</th>
	                    <td id="tContactPerson" colspan="5"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Address</th>
	                    <td id="tAddress" colspan="5"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Remark</th>
	                    <td id="tRemark" colspan="5"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Overdue Amount(RM)</th>
	                    <td id="tOverdue"></td>
	                    <th scope="row">Taxes Amount(RM)</th>
	                    <td id="tTaxes"></td>
	                    <th scope="row">Amount Due(RM)</th>
	                    <td id="tDue"></td>
	                </tr>
	            </tbody>
	        </table>

	        <!-- title_line start -->
	        <aside class="title_line">
	            <h3>Adjustment Information</h3>
	        </aside>
	        <!-- table start -->
	        <table class="type1">
	            <caption>table</caption>
	            <colgroup>
	                <col style="width:200px" />
	                <col style="width:*" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th scope="row">Adjustment Type</th>
	                    <td>
	                        <select id="adjType" name="adjType" ></select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Reason</th>
	                    <td>
	                        <select id="adjReason" name="adjReason"></select>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Remark</th>
	                    <td>
	                        <textarea id="remark" name="remark"></textarea>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Adjustment(RM)</th>
	                    <td id="totAdjustment">0.00</td>
	                </tr>
	            </tbody>
	        </table>
        </form>
        <!-- title_line start -->
        <aside class="title_line">
            <h3>Item(s) Information</h3>
        </aside>
        <!-- table end -->

        <!-- search_result start -->
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->
    </section>
</section>