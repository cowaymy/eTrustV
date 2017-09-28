<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var cancelLogGridID;       // Cancellation Log Transaction list
    var prodReturnGridID;      // Product Return Transaction list
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다. 
        cancelLogGrid();  
        prodReturnGrid();
        
       /*  AUIGrid.setSelectionMode(addrGridID, "singleRow"); */
        //Call Ajax
        fn_cancelLogTransList(); 
        fn_productReturnTransList();
        
        //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };
        
        $(".j_date").datepicker(pickerOpts);

        var monthOptions = {
            pattern: 'mm/yyyy',
            selectedYear: 2017,
            startYear: 2007,
            finalYear: 2027
        };

        $(".j_date2").monthpicker(monthOptions);
    });
    
    function cancelLogGrid(){
        // Cancellation Log Transaction Column
        var cancelLogColumnLayout = [ 
             {dataField : "code1", headerText : "Type", width : '10%'}, 
             {dataField : "code", headerText : "Status", width : '10%'},
             {dataField : "crtDt", headerText : "Create Date", width : '20%'}, 
             {dataField : "callentryUserName", headerText : "Creator", width : '20%'},
             {dataField : "updDt", headerText : "Update Date", width : '20%'}, 
             {dataField : "userName", headerText : "Updator", width : '20%'}
         ];
        
        //그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10(기본값:10)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, //true 
            displayTreeOpen : false, //true
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false, //true
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : false, //false
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        cancelLogGridID = GridCommon.createAUIGrid("#cancelLog", cancelLogColumnLayout,'', gridPros);
    }
    
    function prodReturnGrid(){
        // Product Return Transaction Column
        var prodReturnColumnLayout = [ 
             {dataField : "retnNo", headerText : "Return No", width : '15%'}, 
             {dataField : "code", headerText : "Status", width : '10%'},
             {dataField : "created1", headerText : "Create Date", width : '11%'}, 
             {dataField : "username1", headerText : "Creator", width : '11%'},
             {dataField : "memCodeName2", headerText : "Assign CT"}, 
             {dataField : "ctGrp", headerText : "Group", width : '8%'},
             {dataField : "whLocCodeDesc", headerText : "Return Warehouse", width : '25%'}
         ];
        
        //그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10(기본값:10)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, //true 
            displayTreeOpen : false, //true
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false, //true
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : false, //false
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        prodReturnGridID = GridCommon.createAUIGrid("#productReturn", prodReturnColumnLayout,'',gridPros);
    }
    
    
    
    // 리스트 조회. (Cancellation Log Transaction list)
    function fn_cancelLogTransList() {
        Common.ajax("GET", "/sales/order/cancelLogTransList.do", $("#tabForm").serialize(), function(result) {
            AUIGrid.setGridData(cancelLogGridID, result);
        });
    }
    
    // 리스트 조회. (Product Return Transaction list)
    function fn_productReturnTransList() { 
        Common.ajax("GET", "/sales/order/productReturnTransList.do", $("#tabForm").serialize(), function(result) {
            AUIGrid.setGridData(prodReturnGridID, result);
        });
    }
    
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
        AUIGrid.resize(gridName, 950, 300);
   }
    
    
    function onChangeStatusType(){
    	if($("#addStatus").val() == '19'){     // Recall
    		$("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
            $("select[name=cmbCtGroup]").addClass("w100p disabled");
            $("select[name=cmbCtGroup]").val('');
            $("#addAppRetnDt").attr('disabled','disabled');
            $("#addAppRetnDt").val('');
            $("#addCallRecallDt").removeAttr("disabled");
    	}
    	if($("#addStatus").val() == '32'){     // Confirm To Cancel
            $("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").removeAttr("disabled");
            $("select[name=cmbCtGroup]").removeClass("w100p disabled");
            $("select[name=cmbCtGroup]").addClass("w100p");
            $("#addCallRecallDt").attr('disabled','disabled');
            $("#addCallRecallDt").val('');
            $("#addAppRetnDt").removeAttr("disabled");
        }
    	if($("#addStatus").val() == '31'){     // Reversal Of Cancellation
            $("select[name=cmbAssignCt]").removeAttr("disabled");
            $("select[name=cmbAssignCt]").removeClass("w100p disabled");
            $("select[name=cmbAssignCt]").addClass("w100p");
            $("select[name=cmbFeedbackCd]").removeAttr("disabled");
            $("select[name=cmbFeedbackCd]").removeClass("w100p disabled");
            $("select[name=cmbFeedbackCd]").addClass("w100p");
            $("select[name=cmbCtGroup]").attr('disabled', 'disabled');
            $("select[name=cmbCtGroup]").addClass("w100p disabled");
            $("select[name=cmbCtGroup]").val('');
            $("#addCallRecallDt").attr('disabled','disabled');
            $("#addAppRetnDt").attr('disabled','disabled');
            $("#addCallRecallDt").val('');
            $("#addAppRetnDt").val('');
        }
    	
    }
    
    function fn_saveCancel(){
    	Common.ajax("GET", "/sales/order/saveCancel.do", $("#addCallForm").serializeJSON(), function(result) {
            Common.alert(result.msg);
            $("#addDiv").hide();
        }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                    Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                    }
                catch (e) {
                    console.log(e);
                    alert("Saving data prepration failed.");
                }
                alert("Fail : " + jqXHR.responseJSON.message);
        }); 
    }
    
//    function fn_reloadPage(){
        //Parent Window Method Call
//        fn_orderCancelListAjax();
//        Common.popupDiv('/sales/order/cancelReqInfoPop.do', $('#detailForm').serializeJSON(), null , true, '_editDiv2');
//        $("#_close").click();
//    }
    
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<!-- pop_header start -->
<header class="pop_header">
<h1>Order Cancellation - View</h1>
<ul class="right_opt">
<!-- 
    <li><p class="btn_blue2"><a href="#">COPY</a></p></li>
    <li><p class="btn_blue2"><a href="#">EDIT</a></p></li>
    <li><p class="btn_blue2"><a href="#">NEW</a></p></li>
 -->
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<form id="tabForm" name="tabForm" action="#" method="post">
    <input id="docId" name="docId" type="hidden" value="${paramDocId}">
    <input id="typeId" name="typeId" type="hidden" value="${paramTypeId}">
    <input id="refId" name="refId" type="hidden" value="${paramRefId}">
</form>
<section class="pop_body"><!-- pop_body start -->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Cancellation Request Information</a></dt>
    <dd>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Request No</th>
        <td><span>${cancelReqInfo.reqNo}</span></td>
        <th scope="row">Creator</th>
        <td>${cancelReqInfo.crtUserId}</td>
        <th scope="row">Request Date  </th>
        <td>${cancelReqInfo.callRecallDt}</td>
    </tr>
    <tr>
        <th scope="row">Request Status</th>
        <td><span>${cancelReqInfo.reqStusName}</span></td>
        <th scope="row">Request Stage</th>
        <td>${cancelReqInfo.reqstage}
        </td>
        <th scope="row">Request Reason</th>
        <td>${cancelReqInfo.reqResnCode} - ${cancelReqInfo.reqResnDesc}
        </td>
    </tr>
    <tr>
        <th scope="row">Call Status</th>
        <td>
        <span>${cancelReqInfo.callStusName}</span>
        </td>
        <th scope="row">Recall Date</th>
        <td>${cancelReqInfo.callRecallDt}
        </td>
        <th scope="row">Requestor</th>
        <td>${cancelReqInfo.reqster}
        </td>
    </tr>
    <tr>
        <th scope="row">App Type (On Request)</th>
        <td>
        <span>${cancelReqInfo.appTypeName}</span>
        </td>
        <th scope="row">Stock (On Request)</th>
        <td colspan="3">${cancelReqInfo.stockCode} - ${cancelReqInfo.stockName}
        </td>
    </tr>
    <tr>
        <th scope="row">Outstanding (On Request)</th>
        <td>
        <span>${cancelReqInfo.ordOtstnd}</span>
        </td>
        <th scope="row">Penalty Amt (On Request)</th>
        <td>${cancelReqInfo.pnaltyAmt}
        </td>
        <th scope="row">Adjustment Amt (On Request)</th>
        <td>${cancelReqInfo.adjAmt}
        </td>
    </tr>
    <tr>
        <th scope="row">Grand Total (On Request)</th>
        <td>
        <span>${cancelReqInfo.grandTot}</span>
        </td>
        <th scope="row">Using Months (On Request)</th>
        <td>${cancelReqInfo.usedMth}
        </td>
        <th scope="row">Obligation Months (On Request)</th>
        <td>${cancelReqInfo.obligtMth}
        </td>
    </tr>
    <tr>
        <th scope="row">Under Cooling Off Period ?</th>
        <td>
        <span></span>
        </td>
        <th scope="row">Appointment Date</th>
        <td>${cancelReqInfo.appRetnDg}
        </td>
        <th scope="row">Actual Cancel Date</th>
        <td>${cancelReqInfo.actualCanclDt}
        </td>
    </tr>
    <tr>
        <th scope="row">Bank Account</th>
        <td>
        <span>${cancelReqInfo.bankAcc}</span>
        </td>
        <th scope="row">Issue Bank</th>
        <td>${cancelReqInfo.issBank}
        </td>
        <th scope="row">Account Name</th>
        <td>${cancelReqInfo.accName}
        </td>
    </tr>
    <tr>
        <th scope="row">Attachment</th>
        <td colspan="5">${cancelReqInfo.attach}
        </td>
    </tr>
    <tr>
        <th scope="row">OCR Remark</th>
        <td colspan="5">${cancelReqInfo.reqRem}
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </dd>
    <dt class="click_add_on"><a href="#">Order Full Details</a></dt>
    <dd>
    
    <section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1 num4">
        <li><a href="#" class="on">Basic Info</a></li>
        <li><a href="#">HP / Cody</a></li>
        <li><a href="#">Customer Info</a></li>
        <li><a href="#">Installation Info</a></li>
        <li><a href="#">Mailing Info</a></li>
        <li><a href="#">Membership Info</a></li>
        <li><a href="#">Document Submission</a></li>
        <li><a href="#">Call Log</a></li>
        <li><a href="#">Payment Listing</a></li>
        <li><a href="#">Last 6 Months Transaction</a></li>
        <li><a href="#">Order Configuration</a></li>
        <li><a href="#">Auto Debit Result</a></li>
        <li><a href="#">Relief Certificate</a></li>
        <li><a href="#">Discount</a></li>
    </ul>

    <article class="tap_area"><!-- tap_area start -->
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="#"><span class="search"></span>View Ledger (1)</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="search"></span>View Ledger (2)</a></p></li>
    </ul>

    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Progress Status</th>
        <td>
        <span>111</span>
        </td>
        <th scope="row">Agreement No</th>
        <td>
        </td>
        <th scope="row">Agreement Expiry</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Order No</th>
        <td>
        </td>
        <th scope="row">Order Date</th>
        <td>
        </td>
        <th scope="row">Status</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Application Type</th>
        <td>
        </td>
        <th scope="row">Reference No</th>
        <td>
        </td>
        <th scope="row">Key At (By)</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Product</th>
        <td>
        </td>
        <th scope="row">PO Number</th>
        <td>
        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">PV</th>
        <td>
        </td>
        <th scope="row">Price/RPF</th>
        <td>
        </td>
        <th scope="row">Rental Fees</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Installment Duration</th>
        <td>
        </td>
        <th scope="row">PV Month (month/year)</th>
        <td>
        </td>
        <th scope="row">Rental Status</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Promotion</th>
        <td colspan="3">
        </td>
        <th scope="row">Related No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Serial Number</th>
        <td>
        </td>
        <th scope="row">Sirim Number</th>
        <td>
        </td>
        <th scope="row">Update At (By)</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Obligation Period</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">CCP Feedback Code</th>
        <td colspan="5">
        </td>
    </tr>
    <tr>
        <th scope="row">CCP Remark</th>
        <td colspan="5">
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <div class="divine_auto"><!-- divine_auto start -->

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h2 class="pt0">Salesman Info</h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Order Made By</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Salesman Code</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Salesman Name</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Salesman NRIC</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Office No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">House No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h2 class="pt0">Cody Info</h2>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Service By</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Cody Code</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Cody Name</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Cody NRIC</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Office No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">House No</th>
        <td>
        <span>11111</span>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    </div><!-- divine_auto end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Customer ID</th>
        <td>
        </td>
        <th scope="row">Customer Name</th>
        <td colspan="3">
        </td>
    </tr>
    <tr>
        <th scope="row">Customer Type</th>
        <td>
        </td>
        <th scope="row">NRIC/Company No</th>
        <td>
        </td>
        <th scope="row">JomPay Ref-1</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Nationality</th>
        <td>
        </td>
        <th scope="row">Gender</th>
        <td>
        </td>
        <th scope="row">Race</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">VA Number</th>
        <td>
        </td>
        <th scope="row">Passport Expire</th>
        <td>
        </td>
        <th scope="row">Visa Expire</th>
        <td>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h2 class="pt0">Same Rental Group Order(s)</h2>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Installation Address</th>
        <td colspan="3">
        <span>1111</span>
        </td>
        <th scope="row">Country</th>
        <td>
        </td>
    </tr>
    <tr>
        <td colspan="3">
        <span>1111</span>
        </td>
        <th scope="row">State</th>
        <td>
        </td>
    </tr>
    <tr>
        <td colspan="3">
        <span>1111</span>
        </td>
        <th scope="row">Area</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Prefer Install Date</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">Prefer Install Time</th>
        <td>
        </td>
        <th scope="row">Postcode</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Instruction</th>
        <td colspan="5">
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">DSC Verification Remark</th>
        <td colspan="5">
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">DSC Branch</th>
        <td colspan="3">
        <span>1111</span>
        </td>
        <th scope="row">Installed Date</th>
        <td>
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">CT Code</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">CT Name</th>
        <td colspan="3">
        </td>
    </tr>
    <tr>
        <th scope="row">Contact Name</th>
        <td colspan="3">
        </td>
        <th scope="row">Gender</th>
        <td>
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Contact NRIC</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">Email</th>
        <td>
        </td>
        <th scope="row">Fax No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">Office No</th>
        <td>
        </td>
        <th scope="row">House No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Post</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">Department</th>
        <td>
        </td>
        <th scope="row"></th>
        <td>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:110px" />
        <col style="width:*" />
        <col style="width:110px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row" rowspan="3">Mailing Address</th>
        <td colspan="3">
        <span>111</span>
        </td>
        <th scope="row">Country</th>
        <td>
        </td>
    </tr>
    <tr>
        <td colspan="3">
        <span>111</span>
        </td>
        <th scope="row">State</th>
        <td>
        </td>
    </tr>
    <tr>
        <td colspan="3">
        <span>111</span>
        </td>
        <th scope="row">Area</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Billing Group</th>
        <td>
        <span>111</span>
        </td>
        <th scope="row">Billing Type</th>
        <td>
        <label><input type="checkbox" disabled="disabled" /><span>SMS</span></label>
        <label><input type="checkbox" disabled="disabled" /><span>Post</span></label>
        <label><input type="checkbox" disabled="disabled" /><span>E-statement</span></label>
        </td>
        <th scope="row">Postcode</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Contact Name</th>
        <td colspan="3">
        <span>111</span>
        </td>
        <th scope="row">Gender</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Contact NRIC</th>
        <td>
        <span>111</span>
        </td>
        <th scope="row">Email</th>
        <td>
        </td>
        <th scope="row">Fax No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Mobile No</th>
        <td>
        <span>111</span>
        </td>
        <th scope="row">Office No</th>
        <td>
        </td>
        <th scope="row">House No</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">Post</th>
        <td>
        <span>111</span>
        </td>
        <th scope="row">Department</th>
        <td>
        </td>
        <th scope="row"></th>
        <td>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:120px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">BS Availability</th>
        <td>
        <span>1111</span>
        </td>
        <th scope="row">BS Frequency</th>
        <td>
        </td>
        <th scope="row">Last BS Date</th>
        <td>
        </td>
    </tr>
    <tr>
        <th scope="row">BS Cody Code</th>
        <td colspan="5">
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Config Remark</th>
        <td colspan="5">
        <span>1111</span>
        </td>
    </tr>
    <tr>
        <th scope="row">Happy Call Service</th>
        <td colspan="5">
        <label><input type="checkbox" disabled="disabled" /><span>Installation Type</span></label>
        <label><input type="checkbox" disabled="disabled" /><span>BS Type</span></label>
        <label><input type="checkbox" disabled="disabled" /><span>AS Type</span></label>
        </td>
    </tr>
    <tr>
        <th scope="row">Prefer BS Week</th>
        <td colspan="5">
        <label><input type="radio" name="name" disabled="disabled" /><span>None</span></label>
        <label><input type="radio" name="name" disabled="disabled" /><span>Week 1</span></label>
        <label><input type="radio" name="name" disabled="disabled" /><span>Week 2</span></label>
        <label><input type="radio" name="name" disabled="disabled" /><span>Week 3</span></label>
        <label><input type="radio" name="name" disabled="disabled" /><span>Week 4</span></label>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    
    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    <p><span class="red_text">Disclaimer : This data is subject to Coway private information property which is not meant to view by any public other than coway internal staff only.</span></p>
    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Reference No</th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" />
        </td>
        <th scope="row">Certificate Date</th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">GST Registration No</th>
        <td colspan="3">
        <input type="text" title="" placeholder="" class="" />
        </td>
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan="3">
        <textarea cols="20" rows="5"></textarea>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    그리드 영역
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->

    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(cancelLogGridID)">Cancellation Log Transaction</a></dt>
    <dd>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="cancelLog" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(prodReturnGridID)">Product Return Transaction</a></dt>
    <dd>

    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="productReturn" style="width:100%; height:480px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </dd>
</dl>
</article><!-- acodi_wrap end -->

<div id="addDiv">
<aside class="title_line"><!-- title_line start -->
<h2>Add Call Result</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="addCallForm" name="addCallForm" action="#" method="post">
    <input id="paramdocId" name="paramdocId" type="hidden" value="${paramDocId}">
    <input id="paramtypeId" name="paramtypeId" type="hidden" value="${paramTypeId}">
    <input id="paramrefId" name="paramrefId" type="hidden" value="${paramRefId}">
    <input id="reqStageId" name="reqStageId" type="hidden" value="${reqStageId}">
    <input id="paramCallEntryId" name="paramCallEntryId" type="hidden" value="${cancelReqInfo.callEntryId}">
    <input id="paramReqId" name="paramReqId" type="hidden" value="${cancelReqInfo.reqId}">
    <input id="paramOrdId" name="paramOrdId" type="hidden" value="${cancelReqInfo.ordId}">
    
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:160px" />
	    <col style="width:*" />
	    <col style="width:180px" />
	    <col style="width:*" />
	</colgroup>
		<tbody>
			<tr>
			    <th scope="row">Status<span class="must">*</span></th>
			    <td>
			    <select id="addStatus" name="addStatus" class="w100p" onchange="onChangeStatusType()">
			        <option value="">Call Log Status</option>
			        <option value="19">Recall</option>
			        <option value="32">Confirm To Cancel</option>
			        <option value="31">Reversal Of Cancellation</option>
			    </select>
			    </td>
			    <th scope="row">Feedback Code</th>
			    <td>
			    <select id="cmbFeedbackCd" name="cmbFeedbackCd" class="disabled" disabled="disabled">
                    <option value="">Feedback Code</option>
                    <c:forEach var="list" items="${selectFeedback }">
                        <option value="${list.resnId}">${list.codeResnDesc}</option>
                    </c:forEach>
			    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Assign CT</th>
			    <td>
			    <select id="cmbAssignCt" name="cmbAssignCt" class="w100p">
			        <option value="">Assign CT</option>
                    <c:forEach var="list" items="${selectAssignCTList }">
                        <option value="${list.memId}">${list.memCodeName}</option>
                    </c:forEach>
			    </select>
			    </td>
			    <th scope="row">CT Group</th>
			    <td>
			    <select id="cmbCtGroup" name="cmbCtGroup" class="disabled" disabled="disabled">
			        <option value="">CT Group</option>
			        <option value="A">Group A</option>
			        <option value="B">Group B</option>
			        <option value="C">Group C</option>
			    </select>
			    </td>
			</tr>
			<tr>
			    <th scope="row">Appointment Date</th>
			    <td>
			      <input type="text" id="addAppRetnDt" name="addAppRetnDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" disabled="disabled" />
			    </td>
			    <th scope="row">Recall Date</th>
			    <td>
			      <input type="text" id="addCallRecallDt" name="addCallRecallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" disabled="disabled" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Remark<span class="must">*</span></th>
			    <td colspan="3">
	                <textarea id="addRem" name="addRem" cols="20" rows="5"></textarea>
	            </td>
			</tr>
		</tbody>
	</table><!-- table end -->

</form>
</section><!-- search_table end -->
</div>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_saveCancel()">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->
</div>
