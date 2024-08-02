<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

    var newAdjGridID, approveLineGridID;
    var selectRowIdx;
    var taxRate = "${taxRate}";
    var invoiceDt;
    var oriTaxRate;

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
        { dataField:"billitemtaxcodeid" ,headerText:"<spring:message code='pay.head.billItemTaxCodeId'/>" ,editable : false, visible:false},
        { dataField:"billitemtype" ,headerText:"<spring:message code='pay.head.billType'/>" ,editable : false ,width : 120},
        { dataField:"billitemrefno" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false ,width : 120 },
        { dataField:"billitemunitprice" ,headerText:"<spring:message code='pay.head.unitPrice'/>" ,editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        { dataField:"billitemqty" ,headerText:"<spring:message code='pay.head.quantity'/>" ,editable : false ,width : 100},
        { dataField:"billitemtaxrate" ,
        	headerText:"Tax Rate" ,editable : false , postfix : "%" ,width : 100,
        	expFunction: function (rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.

                var taxRate = item.billitemtaxrate;
                oriTaxRate = item.billitemtaxrate;

                var newInvoiceDt = new Date(item.billitemtaxinvcdt);
                var newSstStartDt = new Date(2024, 3, 1); // mm minus 1 to achieve the date 01-04-2024 SST start date
                var newSstRate = 0;

                if(newInvoiceDt < newSstStartDt && item.billitemtaxrate > 0 && item.billitemtaxrate != 8){
                	taxRate = newSstRate;
                }

                return taxRate;
            }
        },
        { dataField:"billitemcharges" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false , dataType : "numeric",formatString : "#,##0.00" ,width : 120,
        	expFunction: function (rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.

                var itemBillCharge = item.billitemcharges;

                var newInvoiceDt = new Date(item.billitemtaxinvcdt);
                var newSstStartDt = new Date(2024, 3, 1); // mm minus 1 to achieve the date 01-04-2024 SST start date

                if(newInvoiceDt < newSstStartDt && oriTaxRate > 0 && item.billitemtaxrate != 8){
                	itemBillCharge = item.billitemamount;
                }

                return itemBillCharge;
            }
        },
        { dataField:"billitemtaxes" ,headerText:"Tax Amount" ,editable : false , dataType : "numeric",formatString : "#,##0.00" ,width : 120,

        	expFunction: function (rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.

                var billItemTaxes = item.billitemtaxes;

                var newInvoiceDt = new Date(item.billitemtaxinvcdt);
                var newSstStartDt = new Date(2024, 3, 1); // mm minus 1 to achieve the date 01-04-2024 SST start date
                var newBillItemTaxes = 0.00;

                if(newInvoiceDt < newSstStartDt && oriTaxRate > 0 && item.billitemtaxrate != 8){
                		billItemTaxes = 0;
                	billItemTaxes = newBillItemTaxes;
                }

                return billItemTaxes;
            }

        },
        { dataField:"billitemamount" ,headerText:"<spring:message code='pay.head.total'/>" ,editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
        {
            dataField : "totamount",
            headerText : "<spring:message code='pay.head.totalAdjustmentAmount'/>",
            dataType : "numeric",
            width : 200,
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
        }, {
        	dataField:"billTaxAmount" ,
        	headerText:"Total Adjustment Tax Amount" ,
        	editable : false ,
        	visible:false,
        	dataType : "numeric",
        	formatString : "#,##0.00" ,
        	width : 210,
        	expFunction: function (rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.

                var taxAmt = 0;

                if(item.billitemtaxes > 0){
                	taxAmt = item.totamount - (item.totamount / (100 + Number(taxRate)) * 100);
                }
                return taxAmt;
        	}
        }, {
        	dataField:"billNoTaxAmount" ,
            headerText:"Total Adjustment Non Tax Amount" ,
            editable : false ,
            visible:false,
            dataType : "numeric",
            formatString : "#,##0.00" ,
            width : 250,
            expFunction: function (rowIndex, columnIndex, item, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.

                var noTaxAmt = 0;

                if(item.billitemtaxes > 0){
                	noTaxAmt = item.totamount - item.billTaxAmount;
                }
                return noTaxAmt;
            }
        }];

    var approveLineColumnLayout = [
    {
        dataField : "approveNo",
        headerText : '<spring:message code="approveLine.approveNo" />',
        dataType: "numeric",
        expFunction : function( rowIndex, columnIndex, item, dataField ) {
            return rowIndex + 1;
        }
    }, {
        dataField : "memCode",
        headerText : '<spring:message code="approveLine.userId" />',
        colSpan : 2
    }, {
        dataField : "",
        headerText : '',
        width: 30,
        renderer : {
            type : "IconRenderer",
            iconTableRef :  {
                "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"
            },
            iconWidth : 24,
            iconHeight : 24,
            onclick : function(rowIndex, columnIndex, value, item) {
                console.log("selectRowIdx : " + selectRowIdx);
                selectRowIdx = rowIndex;
                fn_searchUserIdPop();
            }
        },
        colSpan : -1
    },{
        dataField : "name",
        headerText : '<spring:message code="approveLine.name" />',
        style : "aui-grid-user-custom-left"
    }, {
        dataField : "",
        headerText : '<spring:message code="approveLine.addition" />',
        renderer : {
            type : "IconRenderer",
            iconTableRef :  {
                "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
            },
            iconWidth : 12,
            iconHeight : 12,
            onclick : function(rowIndex, columnIndex, value, item) {
                var rowCount = AUIGrid.getRowCount(approveLineGridID);
                if (rowCount > 3) {
                    Common.alert('<spring:message code="approveLine.appvLine.msg" />');
                } else {
                    fn_appvLineGridAddRow();
                }
            }
        }
    }];

    // Approval line Grid Option
    var approveLineGridPros = {
            usePaging : true,
            pageRowCount : 20,
            showStateColumn : true,
            enableRestore : true,
            showRowNumColumn : false,
            softRemovePolicy : "exceptNew",
            softRemoveRowMode : false,
            selectionMode : "multipleCells"
    };

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
        newAdjGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
        approveLineGridID = GridCommon.createAUIGrid("#approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);

        //Cell Edit Event : adjustment 금액은 total amount를 초과할수 없음.
        AUIGrid.bind(newAdjGridID, "cellEditEnd", function( event ) {
            var charge = AUIGrid.getCellValue(newAdjGridID, event.rowIndex, "billitemamount"); //invoice charge
            var totamount = AUIGrid.getCellValue(newAdjGridID, event.rowIndex, "totamount"); //transfer amount

            if(charge < totamount){
                AUIGrid.setCellValue(newAdjGridID, event.rowIndex, 'totamount', charge);
            }

            //그리드에서 수정된 총 금액 계산
            auiGridSelectionChangeHandler(event);
            auiGridSelectionChangeHandlerTax(event);
        });

        //초기화면 로딩시 조회
        $("#invoiceNo").val("${refNo}");
        confirmList();

        AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
            console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            selectRowIdx = event.rowIndex;
        });

        fn_appvLineGridAddRow();
    });

    function getAdjustmentInfo(refNo){

        //데이터 조회 (초기화면시 로딩시 조회)
        Common.ajaxSync("GET", "/payment/selectNewAdjList.do", {"refNo":refNo}, function(result) {
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
                invoiceDt = result.master.taxInvcDt;
                $("#tInvoiceType").text(result.master.invoicetype);
                $("#tGroupNo").text(result.master.txinvoicetypeid);
                $("#tOrderNo").text(result.master.ordNo);
                $("#tServiceNo").text(result.master.serviceno);
                $("#CustName").text(result.master.custName);
                $("#tContactPerson").text(result.master.cntcPerson);
                $("#tAddress").text(result.master.address);
                $("#tRemark").text(result.master.rem);
                $("#tOverdue").text(result.master.overdue.toFixed(2));
                $("#tTaxes").text(result.master.taxes.toFixed(2));
                $("#tDue").text(result.master.amountdue.toFixed(2));

                //Detail데이터 출력
                AUIGrid.setGridData(newAdjGridID, result.detail);

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
        var allList = AUIGrid.getGridData(newAdjGridID);
        var val;
        //var val2;
        var sum = 0;
        var oriTaxAmt = 0;

        if(allList.length < 1) {
            $('#totAdjustment').text("0.00");
            return;
        }

        for(i=0; i<allList.length; i++) {
        	oriTaxAmt = AUIGrid.getCellValue(newAdjGridID, i, "billitemtaxes");

       		val = String(AUIGrid.getCellValue(newAdjGridID, i, "totamount")).replace(",", ""); // 컴마 모두 제거
            val = Number(val);

           /*  val2 = String(AUIGrid.getCellValue(newAdjGridID, i, "billTaxAmount")).replace(",", ""); // 컴마 모두 제거
            val2 = Number(val2); */

            if(isNaN(val)) {
                continue;
            }

            /* if(isNaN(val2)) {
                continue;
            } */

            /* val += val2; */
            sum += val;

        }

        //$('#totAdjustment').text(sum.toFixed(2));
        $('#totAdjustment').text(FormUtil.roundNumber(Number(sum),Number(2)).toFixed(2));
    }

    //Total Adjustment Tax Amount 계산
    function auiGridSelectionChangeHandlerTax(event) {
        var allList = AUIGrid.getGridData(newAdjGridID);
        var val3;
        var sum3 = 0;

        if(allList.length < 1) {
            $('#totalAdjustmentTax').val("0.00");
            return;
        }

        for(i=0; i<allList.length; i++) {

        	val3 = String(AUIGrid.getCellValue(newAdjGridID, i, "billTaxAmount")).replace(",", ""); // 컴마 모두 제거
        	val3 = Number(val3);

            if(isNaN(val3)) {
                continue;
            }

            sum3 += val3;

        }

        //$('#totAdjustment').text(sum.toFixed(2));
        $('#totalAdjustmentTax').val(FormUtil.roundNumber(Number(sum3),Number(2)).toFixed(2));
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
        if(Number($("#totAdjustment").text()) == 0){
            Common.alert("* Please fill in the total adjustment amount.");
            return;
        }

         if($("input[name=fileSelector]")[0].files[0] == "" || $("input[name=fileSelector]")[0].files[0] == null) {
             Common.alert("Please attach supporting document!")
             return false;
         }

         $("#appvLinePop").show();
         AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());

         /*
        var formData = Common.getFormData("searchForm");

        Common.ajaxFile("/payment/attachmentUpload.do", formData, function(uResult) {
            console.log(uResult);

            $("#atchFileGrpId").val(uResult.data.fileGroupKey);

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
        });*/
    }

    function fn_submit() {
    	if($("input[name=fileSelector]")[0].files[0] == "" || $("input[name=fileSelector]")[0].files[0] == null) {
            Common.alert("Please attach supporting document!");
            return false;
        }

        var obj = $("#searchForm").serializeJSON();
        obj.apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

        Common.ajax("POST", "/payment/checkFinAppr.do", obj, function(resultFinAppr) {
            console.log(resultFinAppr);

            if(resultFinAppr.code == "99") {
                Common.alert("Please select the relevant final approver.");
            } else {
                //var formData = Common.getFormData("searchForm");
                var formData = Common.getFormData("searchForm");

                Common.ajaxFile("/payment/attachmentUpload.do", formData, function(uResult) {
                    console.log(uResult);

                    $("#atchFileGrpId").val(uResult.data.fileGroupKey);

                  //param data array
                    var data = GridCommon.getGridData(newAdjGridID);
                    data.apprGridList = AUIGrid.getOrgGridData(approveLineGridID);;
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
                });
            }
        });
    }

    /*******************
    Approval Line Functions
    *******************/
   function fn_appvLineGridAddRow() {
       AUIGrid.addRow(approveLineGridID, {}, "first");
   }

   function fn_appvLineGridDeleteRow() {
       AUIGrid.removeRow(approveLineGridID, selectRowIdx);
   }

   function fn_searchUserIdPop() {
       Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
   }

   function fn_newRegistMsgPop() {
       var length = AUIGrid.getGridData(approveLineGridID).length;
       var checkMemCode = true;
       console.log(length);
       // 1개의 default Line 존재
       if(length >= 1) {
           for(var i = 0; i < length; i++) {
               if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
                   Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
                   checkMemCode = false;
               }
           }
       }
       console.log(checkMemCode);
       if(checkMemCode) {
           Common.popupDiv("/eAccounting/webInvoice/newRegistMsgPop.do", null, null, true, "registMsgPop");
       }
   }

   function fn_loadOrderSalesman(memId, memCode) {
       var result = true;
       var list = AUIGrid.getColumnValues(approveLineGridID, "memCode", true);

       if(list.length > 0) {
           for(var i = 0; i < list.length; i ++) {
               if(memCode == list[i]) {
                   result = false;
               }
           }
       }

       if(result) {
           Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

               if(memInfo == null) {
                   Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
               }
               else {
                   console.log(memInfo);
                   AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
                   AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
               }
           });
       } else {
           Common.alert('Not allowed to select same User ID in Approval Line');
       }
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

    <style>
        .tab {
            margin-left: 5px;
            margin-top: 2px;
        }
    </style>

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
            <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" />
            <input type="hidden" id="totalAdjustmentTax" name="totalAdjustmentTax" />
            <input type="hidden" id="totalAdjustmentWithoutTax" name="totalAdjustmentWithoutTax" />

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
	                    <th scope="row">Total Amount(RM)</th>
	                    <td id="tOverdue"></td>
	                    <th scope="row">Tax Amount(RM)</th>
	                    <td id="tTaxes"></td>
	                    <th scope="row">Amount Due(RM)</th>
	                    <td><span id ="tDue"></span> <i class="red_text tab"><spring:message code='sys.common.sst.msg.incld' /></i></td>
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
	                    <th scope="row">Description</th>
	                    <td>
	                        <textarea id="remark" name="remark"></textarea>
	                    </td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Adjustment(RM)</th>
	                    <%-- <td><span id ="totAdjustment">0.00</span> <i class="red_text tab"><spring:message code='sys.common.sst.msg.incld' /></i></td> --%>
	                    <td id="totAdjustment">0.00</td>
	                </tr>
	                <tr>
                        <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                        <td id="attachTd">
                            <div class="auto_file w100p"><!-- auto_file start -->
                                <input type="file" title="file add" style="width:300px" id="fileSelector" name="fileSelector" />
                            </div><!-- auto_file end -->
                        </td>
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

<!-------------------------------------------------------------------------------------
    POP-UP (APPROVAL LINE)
-------------------------------------------------------------------------------------->
    <!-- popup_wrap start -->
    <div class="popup_wrap size_mid2" id="appvLinePop" style="display: none;">
        <header class="pop_header"><!-- pop_header start -->
            <h1><spring:message code="approveLine.title" /></h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <section class="search_result"><!-- search_result start -->
                <ul class="right_btns">
                    <li><p class="btn_grid"><a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
                </ul>

                <article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
                </article><!-- grid_wrap end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2"><a href="javascript:fn_submit()" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                </ul>

            </section><!-- search_result end -->
        </section><!-- pop_body end -->
    </div><!-- popup_wrap end -->
</section>