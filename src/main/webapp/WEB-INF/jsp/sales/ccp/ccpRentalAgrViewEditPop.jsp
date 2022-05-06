<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var consignGridID;
    var msgGridID;
    var orderGridID;
    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var ROLE_ID = "${SESSION_INFO.roleId}";

    //isFile
    var fileResult;

    $(document).ready(function() {

    	//result display
        fn_loadData();

        //createConsignGrid();
        createMsgGrid();
        createOrderGrid();

        //Call Ajax
        fn_getConsignmentAjax();
        fn_getMsgLogAjax();
        fn_getOrderAjax();



        doGetCombo("/sales/ccp/getRentalMessageStatusCode.do", $("#_prgId").val() , '', '_msgStatus', 'S', '' );

        console.log("_prgId : " + $("#_prgId").val());
        console.log("_UpdPrgId : " + $("#_updPrgId").val());

        //hide all editable fields, until click edit button
        fn_disable_all();
        $("#_btnCancel").css("display" , "none");

        var agrStatus = $("#_prgId").val();
        var stusId = $("#_govAgStusId").val();
        if(stusId == 4 || stusId == 10){
            $("#_agrResult").css("display" , "none");
        }else{
        	if(ROLE_ID == "262" || ROLE_ID == "264" || ROLE_ID == "267" || ROLE_ID == "130"){
                $("#_btnCancel").css("display" , "");
            }
        }
        /* if(agrStatus == '10'){
        	$("#_btnEdit").css("display" , "none");
        }else{ */
        	$("#_btnSave").css("display" , "none");

        //}
        //Agreement Result Display
        //fn_hideAgrResult();

      //Order Search
        $("#_newOrderSearch").click(function() {
            Common.popupDiv('/sales/ccp/searchOrderNoByEditPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchEditDiv');
        });

        // New Order Add
        $("#_newOrderConfirm").click(function() {

            var tempInputval = $("#_inputConfirmNewOrder").val();
            fn_getOrderIdResult(tempInputval);

        });

        // New Order Remove
        $("#_newOrderRemove").click(function() {
        	var selectedItem = AUIGrid.getSelectedItems(orderGridID);
        	if(selectedItem.length <= 0){
                Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
                return;
            }
        	var ordId = selectedItem[0].item.salesOrdId;
        	var originalOrdId = $("#_salesOrdId").val();
            if(originalOrdId == ordId){
                Common.alert('<spring:message code="sal.alert.msg.itmDisaRemvFromList" />');
            }else{
                 AUIGrid.removeRow(orderGridID, "selectedIndex");
                 AUIGrid.removeSoftRows(orderGridID);
                 Common.alert('<spring:message code="sal.alert.msg.itmHasbeenRemvFromList" />');
            }
        });

        function fn_getOrderIdResult(ordNum){

            $.ajax({

                type : "GET",
                url : getContextPath() + "/sales/ccp/getOrderId",
                contentType: "application/json;charset=UTF-8",
                crossDomain: true,
                data: {salesOrderNo : ordNum},
                dataType: "json",
                success : function (data) {

                    var ordId = data.ordId;
                    console.log(ordId);
                    $("#_addOrdId").val(ordId);
                    Common.ajax("GET", "/sales/ccp/selectOrderRentalAddJsonList", $("#_newOrderAddForm").serialize(), function(result){
                        AUIGrid.addRow(orderGridID, result, "last");
                    });
                    $("#_inputConfirmNewOrder").val("");
                },
                error : function (data) {
                    if(data == null){               //error
                        Common.alert('<spring:message code="sal.alert.msg.failToLoadDb" />');
                    }else{                            // No data
                        Common.alert('<spring:message code="sal.alert.msg.noOrdFoundOrder" />');
                    }


                }
            });
        }

        $("#_btnSave").click(function() {

            var isResult = false;

            isResult = fn_validation();

            if(isResult == false){
                return;
            }

            if($("#_sendSmsSales").is(":checked") == true){
            	$("#_isSendSales").val("1");
            }else{
            	$("#_isSendSales").val("0");
            }
            if($("#_sendSmsCody").is(":checked") == true){
                $("#_isSendCody").val("1");
            }else{
                $("#_isSendCody").val("0");
            }
            //SMS
            if($("#_updSmsChk").is(":checked") == true){
                $("#_isChkSms").val("1");

                //msg setting
                var realMsg =   $("#_updSmsMsg").val();
                $("#_hiddenUpdSmsMsg").val(realMsg); //msg contents
                var salesmanPhNum = $("#_editSalesManTelMobile").val();
                $("#_hiddenSalesMobile").val(salesmanPhNum);
                var codyPhNum = $("#_editCodyTelMobile").val();
                $("#_hiddenCodyMobile").val(codyPhNum);

            }else{
                $("#_isChkSms").val("0");
            }

            if($("#_erlTerNonCrisisChk").is(":checked") == true){
            	$("#_isErlTerNonCrisisChk").val('1');
            }else{
            	$("#_isErlTerNonCrisisChk").val('0');
            }

            //Validation Success ()
            $("#_hiddenUpdMsgStatus").val($("#_msgStatus").val());

            var data ={};
            var param = AUIGrid.getGridData(orderGridID);
            var gridData = GridCommon.getEditData(orderGridID);

            //upload attachment
            var formData = Common.getFormData("_saveForm");
            //formData.append("updMsgId", $("#_updAgrId").val());

            if($("#_fileName").val() == ""){
            	console.log("file name is null");
            	//data.add = param;
                //data.form = $("#_saveForm").serialize();
                data.form = $("#_saveForm").serializeJSON();
                data.gridData = gridData;

                Common.ajax("POST", "/sales/ccp/updateRentalAgrMtcEdit.do", data , function(result){
                    //msg
                    //result.msgLogSeq
                    $("#_upMsgId").val(result.msgLogSeq);
                    //Save Btn Disable
                    $("#_btnSave").css("display" , "none");
                    //List Reload
                    fn_selectCcpAgreementListAjax();
                    //Common.confirm('<spring:message code="sal.confirm.msg.wantToUpload" />' , fn_fileUpload , "");
                    fn_disable_all();
                    Common.alert("Updated Successfully.");
                    //Send E-Mail
                    if( ("7" == $("#_updPrgId").val() && "5" == $("#_msgStatus").val()) || "8" == $("#_updPrgId").val()){

                        Common.ajax("GET", "/sales/ccp/sendRentalUpdateEmail.do", result, function(result){
                            console.log(result.message);

                       });
                    }
                });
            }else{
            	console.log("file name not null");
            	var fileName = $("#_fileName").val().split('\\');
            	formData.append("updMsgId", fileName[fileName.length -1]);
            	Common.ajaxFile("/sales/ccp/uploadRentalCcpFile.do", formData, function(result){
                    console.log("result.data " + result.data.fileGroupKey);
                    $("#_fileGroupKey").val(result.data.fileGroupKey);
                    Common.setMsg("<spring:message code='sys.msg.success'/>");


                  //data.add = param;
                    //data.form = $("#_saveForm").serialize();
                    data.form = $("#_saveForm").serializeJSON();
                    data.gridData = gridData;

                    Common.ajax("POST", "/sales/ccp/updateRentalAgrMtcEdit.do", data , function(result){
                        //msg
                        //result.msgLogSeq
                        $("#_upMsgId").val(result.msgLogSeq);
                        //Save Btn Disable
                        $("#_btnSave").css("display" , "none");
                        fn_disable_all();
                        Common.alert("Updated Successfully.");
                        //List Reload
                        fn_selectCcpAgreementListAjax();
                        //Common.confirm('<spring:message code="sal.confirm.msg.wantToUpload" />' , fn_fileUpload , "");

                        //Send E-Mail
                        if( ("7" == $("#_updPrgId").val() && "5" == $("#_msgStatus").val()) || "8" == $("#_updPrgId").val()){

                            Common.ajax("GET", "/sales/ccp/sendRentalUpdateEmail.do", result, function(result){
                                console.log(result.message);

                           });
                        }
                    });

                }, function (jqXHR, textStatus, errorThrown) {
                    Common.alert("<spring:message code='sys.msg.fail'/>");
                    Common.setMsg("<spring:message code='sys.msg.fail'/>");
                });
            }


        });//btn Save End

        $("#_addNewConsign").click(function() {

            Common.popupDiv("/sales/ccp/addNewConsign.do", $("#_saveForm").serializeJSON(), null , true , '_consignDiv');

        });

        $("#_btnEdit").click(function() {
        	$("#_btnEdit").css("display" , "none");
        	$("#_btnSave").css("display" , "");

        	//follow the agreement status, show/hide each of the fields
            fn_editable_fields();
        });


        $("#_btnCancel").click(function() {
        	Common.confirm('Are you sure you want to cancel this agreement ? ', fn_cancelAgm , "");


        });

	    // add early termination non crisis flag - only available at Agreement Verifying stage by Hui Ding, 2020-09-21
	    if ($("#_updErlTerNonCrisisChk").val() == '1'){
            $("#_erlTerNonCrisisChk").prop("checked" , true);
        } else{
            $("#_erlTerNonCrisisChk").prop("checked" , false);
        }

    }); // Document Ready End

    function createMsgGrid(){
        //govAgMsgAttachFileName
        var msgColumnLayout = [

                                   {dataField : "userName" , headerText : '<spring:message code="sal.text.creator" />' , width : "10%"},
                                   {dataField : "govAgMsgCrtDt" , headerText : '<spring:message code="sal.text.created" />' , width : "10%"},
                                   {dataField : "name" , headerText : '<spring:message code="sal.title.status" />' , width : "10%"},
                                   {dataField : "govAgPrgrsName" , headerText : '<spring:message code="sal.title.text.prgss" />' , width : "10%"},
                                   {dataField : "govAgRoleDesc" , headerText : '<spring:message code="sal.text.dept" />' , width : "10%"},
                                   {dataField : "govAgMsg" , headerText : '<spring:message code="sal.title.text.msg" />' , width : "30%"},
                                   {dataField : "govAgMsgHasAttach" , headerText : '<spring:message code="sal.title.text.attatch" />' , width : "10%"},
                                   {dataField : "atchFileGrpId" , visible : false},
                                   {dataField : "atchFileId",  headerText : '<spring:message code="sal.title.text.download" />', width : '10%', styleFunction : cellStyleFunction,
                                         renderer : {
                                           type : "ButtonRenderer",
                                           labelText : "Download",
                                           onclick : function(rowIndex, columnIndex, value, item) {

                                               Common.showLoader();
                                                var fileId = value;
                                              $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                                                   httpMethod: "POST",
                                                   contentType: "application/json;charset=UTF-8",
                                                   data: {
                                                       fileId: fileId
                                                   },
                                                   failCallback: function (responseHtml, url, error) {
                                                       Common.alert($(responseHtml).find("#errorMessage").text());
                                                   }
                                               }).done(function () {
                                                       Common.removeLoader();
                                                       console.log('File download a success!');
                                               }).fail(function () {
                                                       Common.alert('<spring:message code="sal.alert.msg.fileMissing" />');
                                                       Common.removeLoader();
                                               });



                                           }
                                         }
                                     },
                                     {dataField : "smsContent" , headerText : 'SMS' , width : "30%"}
                                     ];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : false,
                displayTreeOpen     : false,
       //         selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        msgGridID = GridCommon.createAUIGrid("msgLog_grid_wrap", msgColumnLayout,'', gridPros);

    }

    function createOrderGrid(){

        var orderColumnLayout = [
                               {dataField : "salesOrdId",   visible : false},
                               {dataField : "salesOrdNo" , headerText : '<spring:message code="sal.text.ordNo" />' , width : "20%"},
                               {dataField : "name" , headerText : '<spring:message code="sal.title.text.customer" />' , width : "40%"},
                               {dataField : "ordStatus" , headerText : '<spring:message code="sal.text.orderStatus" />' , width : "20%"},
                               {dataField : "stkDesc" , headerText : '<spring:message code="sal.title.text.productModel" />' , width : "20%"},
                               {dataField : "ordMthRental" , headerText : '<spring:message code="sal.title.text.finalRentalFees" />' , width : "20%"}
        ];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
    //            selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        orderGridID = GridCommon.createAUIGrid("order_grid_wrap", orderColumnLayout,'', gridPros);
    }

    $(function(){
    	$("#_erlTerNonCrisisChk").change(function(){
    		var prevChk = $("#_updErlTerNonCrisisChk").val() == 1? true:  false;

            if ($("#_prgId").val() != '8'){
            	Common.alert("[Early Termination Non N/Crisis] flag only allow to be edited at [Agreement Verifying] stage.");
            	$("#_erlTerNonCrisisChk").prop("checked" , prevChk);
            }
        });

    	$('#_updSmsMsg').keyup(function (e){

            var content = $(this).val();

           // $(this).height(((content.split('\n').length + 1) * 2) + 'em');

            $('#_charCounter').html('Total Character(s) : '+content.length);
        });

    	$("#_msgStatus").change(function() {
    	    $("#_msgStatusUpd").val('Y');
    	    setRemResultMessage('1', "Message Status " + $("#_msgStatus :Selected").text());
    	});
    	$("#_govAgTypeId").change(function() {
    	    $("#_govAgTypeIdUpd").val('Y');
    	    setRemResultMessage('1', "Agreement Type " + $("#_govAgTypeId :Selected").text());
    	});
    	$("#_govAgQty").change(function() {
    	    $("#_govAgQtyUpd").val('Y');
    	    setRemResultMessage('1', "No. of copies " + $("#_govAgQty").val());
    	});
    	$("#_govAgStartDt").change(function() {
    	    $("#_govAgStartDtUpd").val('Y');
    	    setRemResultMessage('1', "Contract Commencement Date " + $("#_govAgStartDt").val());
    	});
    	$("#_govAgEndDt").change(function() {
    	    $("#_govAgEndDtUpd").val('Y');
    	    setRemResultMessage('1', "Contract Expiry Date " + $("#_govAgEndDt").val());
    	});
    	$("#_cowayTemplate").change(function() {
    	    $("#_cowayTemplateUpd").val('Y');
    	    setRemResultMessage('1', "Coway's Template " + $("#_cowayTemplate :Selected").text());
    	});
    	$("#_cntPeriodValue").change(function() {
    	    $("#_cntPeriodValueUpd").val('Y');
    	    setRemResultMessage('1', "Contract Period " + $("#_cntPeriodValue").val());
    	});
    	$("#_draftRcvd").change(function() {
    	    $("#_draftRcvdUpd").val('Y');
    	    setRemResultMessage('1', "Received Customer’s Draft " + $("#_draftRcvd").val());
    	});
    	$("#_firstReview").change(function() {
    	    $("#_firstReviewUpd").val('Y');
    	    setRemResultMessage('1', "1st Review " + $("#_firstReview").val());
    	});
    	$("#_isSecReview").change(function() {
    	    $("#_isSecReviewUpd").val('Y');
    	    $("#_secReviewUpd").val('Y');
    	    if($("#_isSecReview").val() == '0'){
    	        $("#_secReview").val('');
    	    }
    	});
    	$("#_secReview").change(function() {
    	    $("#_secReviewUpd").val('Y');
    	    setRemResultMessage('1', "2nd Review " + $("#_secReview").val());
    	});
    	$("#_isThirdReview").change(function() {
    	    $("#_isThirdReviewUpd").val('Y');
    	    $("#_thirdReviewUpd").val('Y');
    	    if($("#_isThirdReview").val() == '0'){
    	        $("#_thirdReview").val('');
    	    }
    	});
    	$("#_thirdReview").change(function() {
    	    $("#_thirdReviewUpd").val('Y');
    	    setRemResultMessage('1', "3rd Review " + $("#_thirdReview").val());
    	});
    	$("#_isFirstFeedback").change(function() {
    	    $("#_isFirstFeedbackUpd").val('Y');
    	    $("#_firstFeedbackUpd").val('Y');
    	    if($("#_isFirstFeedback").val() == '0'){
    	        $("#_firstFeedback").val('');
    	    }
    	});
    	$("#_firstFeedback").change(function() {
    	    $("#_firstFeedbackUpd").val('Y');
    	    setRemResultMessage('1', "Received 1st Feedback from Customer " + $("#_firstFeedback").val());
    	});
    	$("#_isSecFeedback").change(function() {
    	    $("#_isSecFeedbackUpd").val('Y');
    	    $("#_thirdReviewUpd").val('Y');
    	    if($("#_isThirdReview").val() == '0'){
    	        $("#_thirdReview").val('');
    	    }
    	});
    	$("#_secFeedback").change(function() {
    	    $("#_secFeedbackUpd").val('Y');
    	    setRemResultMessage('1', "Received 2nd Feedback from Customer " + $("#_secFeedback").val());
    	});
    	$("#_isLatestFwd").change(function() {
    	    $("#_isLatestFwdUpd").val('Y');
    	    $("#_latestFwdUpd").val('Y');
    	    if($("#_isLatestFwd").val() == '0'){
    	        $("#_latestFwd").val('');
    	    }
    	});
    	$("#_latestFwd").change(function() {
    	    $("#_latestFwdUpd").val('Y');
    	    setRemResultMessage('1', "RFD/Business Unit Approval Received " + $("#_latestFwd").val());
    	});
    	$("#_isRfd").change(function() {
    	    $("#_isRfdUpd").val('Y');
    	    $("#_rfdUpd").val('Y');
    	    if($("#_isRfd").val() == '0'){
    	        $("#_rfd").val('');
    	    }
    	});
    	$("#_rfd").change(function() {
    	    $("#_rfdUpd").val('Y');
    	    setRemResultMessage('1', "RFD Required " + $("#_rfd").val());
    	});
    	$("#_agrExecution").change(function() {
    	    $("#_agrExecutionUpd").val('Y');
    	    setRemResultMessage('1', "Agreement Executed " + $("#_agrExecution").val());
    	});
    	$("#_agrFinal").change(function() {
    	    $("#_agrFinalUpd").val('Y');
    	    setRemResultMessage('1', "Agreement Finalised " + $("#_agrFinal").val());
    	});
    	$("#_sendStamping").change(function() {
    	    $("#_sendStampingUpd").val('Y');
    	    setRemResultMessage('1', "Sent for stamping " + $("#_sendStamping").val());
    	});
    	$("#_receiveStamp").change(function() {
    	    $("#_receiveStampUpd").val('Y');
    	    setRemResultMessage('1', "Received Stamp Certificate  " + $("#_receiveStamp").val());
    	});
    	$("#_courier").change(function() {
    	    $("#_courierUpd").val('Y');
    	    setRemResultMessage('1', "Courier Out " + $("#_courier").val());
    	});
    	$("#_erlTerNonCrisisChk").change(function() {
            $("#_erlTerNonCrisisChkUpd").val('Y');
            if($("#_erlTerNonCrisisChk").is(":checked") == true){
            	setRemResultMessage('1', "Contract Contains Early Termination Clause Yes");
            }else{
            	setRemResultMessage('1', "Contract Contains Early Termination Clause No");
            }
        });
    });

    $("#_updSmsChk").change(function() {
        //Init
        $("#_updSmsMsg").val('');
        $("#_updSmsMsg").attr("disabled" , "disabled");
        $('#_charCounter').html();
        if($("#_updSmsChk").is(":checked") == true){
            /* if(isAllowSendSMS() == true){
                $("#_updSmsMsg").attr("disabled" , false);
                setSMSMessage();
            } */

            $("#_updSmsChk").prop('checked', true) ;
            $("#_updSmsMsg").attr("disabled" , false);
            setSMSMessage(1,'');
        }
    });

    function fn_disable_all(){

    	$("#addOrd").css("display" , "none");

    	$("#_msgStatus").attr("disabled" , "disabled");
    	$("#_govAgTypeId").attr("disabled" , "disabled");
    	$("#_govAgQty").attr("disabled" , "disabled");
    	$("#_govAgStartDt").attr("disabled" , "disabled");
    	$("#_govAgEndDt").attr("disabled" , "disabled");
        $("#_cowayTemplate").attr("disabled" , "disabled");
        $("#_cntPeriodValue").attr("disabled" , "disabled");
        $("#_draftRcvd").attr("disabled" , "disabled");
        $("#_firstReview").attr("disabled" , "disabled");
        $("#_isSecReview").attr("disabled" , "disabled");
        $("#_secReview").attr("disabled" , "disabled");
        $("#_isThirdReview").attr("disabled" , "disabled");
        $("#_thirdReview").attr("disabled" , "disabled");
        $("#_isFirstFeedback").attr("disabled" , "disabled");
        $("#_firstFeedback").attr("disabled" , "disabled");
        $("#_isSecFeedback").attr("disabled" , "disabled");
        $("#_secFeedback").attr("disabled" , "disabled");
        $("#_erlTerNonCrisisChk").attr("disabled" , "disabled");
        $("#_isLatestFwd").attr("disabled" , "disabled");
        $("#_latestFwd").attr("disabled" , "disabled");
        $("#_isRfd").attr("disabled" , "disabled");
        $("#_rfd").attr("disabled" , "disabled");
        $("#_agrExecution").attr("disabled" , "disabled");
        $("#_agrFinal").attr("disabled" , "disabled");
        $("#_sendStamping").attr("disabled" , "disabled");
        $("#_receiveStamp").attr("disabled" , "disabled");
        $("#_courier").attr("disabled" , "disabled");

        $("#_resultRemark").attr("disabled" , "disabled");

        $("#_updSmsChk").attr("disabled" , "disabled");
        $("#_sendSmsSales").attr("disabled" , "disabled");
        $("#_sendSmsCody").attr("disabled" , "disabled");
        $("#_updSmsMsg").attr("disabled" , "disabled");
    }

    function fn_editable_fields(){
    	var agrStatus = $("#_prgId").val();

    	if(agrStatus == '7'){//submission
    		$("#_govAgTypeId").attr("disabled" , false);
    		$("#_govAgStartDt").attr("disabled" , false);
            $("#_govAgEndDt").attr("disabled" , false);
    		$("#_cowayTemplate").attr("disabled" , false);
    		$("#_govAgQty").attr("disabled" , false);
    		$("#_cntPeriodValue").attr("disabled" , false);
    		$("#_draftRcvd").attr("disabled" , false);
    		$("#addOrd").css("display" , "");
    	}
    	if(agrStatus == '8'){//verify
    		$("#_cowayTemplate").attr("disabled" , false);
    		$("#_cntPeriodValue").attr("disabled" , false);
    		$("#_govAgStartDt").attr("disabled" , false);
            $("#_govAgEndDt").attr("disabled" , false);
    		$("#_govAgQty").attr("disabled" , false);
    		$("#_firstReview").attr("disabled" , false);
    		$("#_isSecReview").attr("disabled" , false);
    		$("#_secReview").attr("disabled" , false);
    		$("#_isThirdReview").attr("disabled" , false);
    		$("#_thirdReview").attr("disabled" , false);
    		$("#_isFirstFeedback").attr("disabled" , false);
    		$("#_firstFeedback").attr("disabled" , false);
    		$("#_isSecFeedback").attr("disabled" , false);
    		$("#_secFeedback").attr("disabled" , false);
    		$("#_erlTerNonCrisisChk").attr("disabled" , false);
    		$("#_isLatestFwd").attr("disabled" , false);
    		$("#_latestFwd").attr("disabled" , false);
    		$("#_isRfd").attr("disabled" , false);
    		$("#_rfd").attr("disabled" , false);
    		$("#_agrFinal").attr("disabled" , false);
    		$("#addOrd").css("display" , "");
        }
    	if(agrStatus == '11'){//execution
    		$("#_agrExecution").attr("disabled" , false);
    		$("#_sendStamping").attr("disabled" , false);
        }
    	if(agrStatus == '9'){//stamping
    		$("#_receiveStamp").attr("disabled" , false);
    		$("#_courier").attr("disabled" , false);
        }
    	if(agrStatus == '10'){//filling
        }

   		$("#_msgStatus").attr("disabled" , false);


   		if(agrStatus != '10'){//filling
   			$("#_resultRemark").attr("disabled" , false);
   			$("#_updSmsChk").attr("disabled" , false);
   	        $("#_sendSmsSales").attr("disabled" , false);
   	        $("#_sendSmsCody").attr("disabled" , false);
   	        $("#_updSmsMsg").attr("disabled" , false);
   	     $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Delete</a></span>");
        }


    }

    function setRemResultMessage(status, remark){
        var msg = $("#_resultRemark").val();

        if(msg != ""){
            msg = msg + " | " + remark;
        }else{
        	msg = remark;
        }

        console.log("msg " + msg);
        $("#_resultRemark").val(msg);

        //Msg Count Init
        $('#_charCounter').html('Total Character(s) : '+ msg.length);
    }

    function setSMSMessage(status, remark){
    	var salesmanMemTypeID  = $("#_editSalesMemTypeId").val();
        var custName = $("#_custName").val().trim();
        var ordNo = $("#_editDocNo").val();
        var message = "AGM No : " + ordNo + "\n" + "Cust Name : " + custName + "\n" + "Remark :" + remark + "\n";

        $("#_updSmsMsg").val(message);

        //Msg Count Init
        $('#_charCounter').html('Total Character(s) : '+ message.length);
    }

    function fn_fileUpload(){

        var uploadParam = {msgId : $("#_upMsgId").val()};
        console.log("edit upload Params  : " + JSON.stringify(uploadParam));
        Common.popupDiv("/sales/ccp/openFileUploadPop.do", uploadParam , null , true , '_uploadDiv');

    }

    function fn_loadData(){
    	$("#_govAgTypeId").val('${infoMap.govAgTypeId}');
    	$("#_govAgQty").val('${infoMap.govAgQty}');
    	$("#_govAgStartDt").val('${infoMap.govAgStartDt}');
    	$("#_govAgEndDt").val('${infoMap.govAgEndDt}');
    	$("#_cowayTemplate").val('${infoMap.govAgTemplate}');
    	$("#_cntPeriodValue").val('${infoMap.govAgPeriod}');
    	$("#_draftRcvd").val('${infoMap.govAgDraftDt}');
    	$("#_firstReview").val('${infoMap.govAgFirstRevDt}');
    	$("#_isSecReview").val('${infoMap.isGovAgSecRev}');
    	$("#_secReview").val('${infoMap.govAgSecRevDt}');
    	$("#_isThirdReview").val('${infoMap.isGovAgThirdRev}');
    	$("#_thirdReview").val('${infoMap.govAgThirdRevDt}');
    	$("#_isFirstFeedback").val('${infoMap.isGovAgFirstFeed}');
    	$("#_firstFeedback").val('${infoMap.govAgFirstFeedDtDt}');
    	$("#_isSecFeedback").val('${infoMap.isGovAgSecFeed}');
    	$("#_secFeedback").val('${infoMap.govAgSecFeedDt}');
    	$("#_isLatestFwd").val('${infoMap.isGovAgOthDept}');
    	$("#_latestFwd").val('${infoMap.govAgOthDeptDt}');
    	$("#_isRfd").val('${infoMap.isGovAgRfd}');
    	$("#_rfd").val('${infoMap.govAgRfdDt}');
    	$("#_agrExecution").val('${infoMap.govAgExeDt}');
    	$("#_agrFinal").val('${infoMap.govAgFinalDt}');
    	$("#_sendStamping").val('${infoMap.govAgSentStampDt}');
    	$("#_receiveStamp").val('${infoMap.govAgRecStampDt}');
    	$("#_courier").val('${infoMap.govAgCourierDt}');
    }

    /* ### Call Ajax ### */
    function fn_getConsignmentAjax(){
         Common.ajax("GET", "/sales/ccp/selectRentalConsignmentLogAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(consignGridID, result);

         });
    }

    function fn_getMsgLogAjax(){
         Common.ajax("GET", "/sales/ccp/selectRentalMessageLogAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(msgGridID, result);

         });
    }

    function fn_getOrderAjax(){
         Common.ajax("GET", "/sales/ccp/selectRentalContactOrdersAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(orderGridID, result);

         });
    }

    function fn_resizeFun(value){

        if(value == 'agrInfo'){
             AUIGrid.resize(consignGridID, 940, 250);
             AUIGrid.resize(msgGridID, 940, 250);

        }

        /* if(value == 'order'){
            AUIGrid.resize(orderGridID, 940, 250);
        } */
    }

    function fn_hideAgrResult(){

        //Agreement Type
        $("#_govAgTypeId").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});

        //Agreement Period
        $("#_agrPeriodStart").attr("disabled" , "disabled");
        $("#_agrPeriodEnd").attr("disabled" , "disabled");

        //Agreement Result Remark
        $("#_resultRemark").attr("disabled" , "disabled");

        //Agreement Result (Div Tag)
        var stusId = $("#_govAgStusId").val();
        if(stusId == 4 || stusId == 10){
            $("#_agrResult").css("display" , "none");
        }else{
            $("#_agrResult").css("display" , "");
        }
    }

    function fn_statusChangeFunc(inputVal){

        //InitField
        //fn_intiField();

        var tempVal = inputVal;

        if(tempVal == null || tempVal == ''){
            fn_hideAgrResult();
        }else{
            //Remark
            $("#_resultRemark").attr("disabled" , false);

            //Progress ID
            if($("#_prgId").val() == '10'){
                $("#_govAgTypeId").attr({"disabled" : false , "class" : "wp100"});
            }else{
                $("#_govAgTypeId").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
            }

            //inputValue Compare
            if(tempVal == '6' ||tempVal == '10'){

                $("#_govAgTypeId").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
                $("#_agrPeriodStart").attr("disabled" , "disabled");
                $("#_agrPeriodEnd").attr("disabled" , "disabled");

            }else{

                $("#_agrPeriodStart").attr("disabled" , false );
                $("#_agrPeriodEnd").attr("disabled" , false );
            }
        }
    }

    function fn_validation(){

        //msgStatus
        if(null == $("#_msgStatus").val() || '' == $("#_msgStatus").val() ){

            Common.alert('<spring:message code="sal.alert.msg.agrPrgsStusReq" />');
            return false;
        }

        if($("#_prgId").val() == '7'){

            if($("#_msgStatus").val() == '6' ){

                if(null == $("#_agrPeriodStart").val() || '' == $("#_agrPeriodStart").val() || null == $("#_agrPeriodEnd").val() || '' == $("#_agrPeriodEnd").val() ){
                    Common.alert('* Contract Commencement Date cannot bigger than Contract Expiry Date.');
                    return false;
                }
            }
        }

        //Start Date , End Date
        if($("#_msgStatus").val() == '5'){

        	var agrStatus = $("#_prgId").val();

        	if(agrStatus == '7'){//submission
        		if(null == $("#_govAgStartDt").val() || '' == $("#_govAgStartDt").val()){
                    Common.alert('Contract Commencement Date is required.');
                    return false;
                }

                if(null == $("#_govAgEndDt").val() || '' == $("#_govAgEndDt").val()){
                    Common.alert('Contract Expiry Date is required.');
                    return false;
                }
                if(null == $("#_cowayTemplate").val() || '' == $("#_cowayTemplate").val()){
                    Common.alert("Coway's Template is required.");
                    return false;
                }
                if(null == $("#_govAgQty").val() || '' == $("#_govAgQty").val()){
                    Common.alert('No. of copies is required.');
                    return false;
                }
                if(null == $("#_cntPeriodValue").val() || '' == $("#_cntPeriodValue").val() || '0' == $("#_cntPeriodValue").val()){
                    Common.alert('Contract Period is required.');
                    return false;
                }
            }
            if(agrStatus == '8'){//verify
            	if(null == $("#_cowayTemplate").val() || '' == $("#_cowayTemplate").val()){
                    Common.alert("Coway's Template is required.");
                    return false;
                }
                if(null == $("#_govAgQty").val() || '' == $("#_govAgQty").val()){
                    Common.alert('No. of copies is required.');
                    return false;
                }
                if(null == $("#_cntPeriodValue").val() || '' == $("#_cntPeriodValue").val() || '0' == $("#_cntPeriodValue").val()){
                    Common.alert('Contract Period is required.');
                    return false;
                }
                if(null == $("#_firstReview").val() || '' == $("#_firstReview").val()){
                    Common.alert('1st Review is required.');
                    return false;
                }
                if($("#_isSecReview").val() == "1" && (null == $("#_secReview").val() || '' == $("#_secReview").val())){
                    Common.alert('2nd Review is required.');
                    return false;
                }
                if($("#_isThirdReview").val() == "1" && (null == $("#_thirdReview").val() || '' == $("#_thirdReview").val())){
                    Common.alert('3rd Review is required.');
                    return false;
                }
                if($("#_isFirstFeedback").val() == "1" && (null == $("#_firstFeedback").val() || '' == $("#_firstFeedback").val())){
                    Common.alert('Received 1st Feedback from Customer  is required.');
                    return false;
                }
                if($("#_isSecFeedback").val() == "1" && (null == $("#_secFeedback").val() || '' == $("#_secFeedback").val())){
                    Common.alert('Received 2nd Feedback from Customer is required.');
                    return false;
                }
                if($("#_isLatestFwd").val() == "1" && (null == $("#_latestFwd").val() || '' == $("#_latestFwd").val())){
                    Common.alert('RFD/Business Unit Approval Received is required.');
                    return false;
                }
                if($("#_isRfd").val() == "1" && (null == $("#_rfd").val() || '' == $("#_rfd").val())){
                    Common.alert('RFD Required is required.');
                    return false;
                }
                if(null == $("#_agrFinal").val() || '' == $("#_agrFinal").val()){
                    Common.alert('Agreement Finalised is required.');
                    return false;
                }

            }
            if(agrStatus == '11'){//execution
            	if(null == $("#_agrExecution").val() || '' == $("#_agrExecution").val()){
                    Common.alert('Agreement Executed is required.');
                    return false;
                }
            }
            if(agrStatus == '9'){//stamping
            	if(null == $("#_receiveStamp").val() || '' == $("#_receiveStamp").val()){
                    Common.alert('Received Stamp Certificate is required.');
                    return false;
                }
                if(null == $("#_courier").val() || '' == $("#_courier").val()){
                    Common.alert('Courier Out is required.');
                    return false;
                }
            }

        	var startDateAr = $("#_govAgStartDt").val().split('/');
            var endDateAr = $("#_govAgEndDt").val().split('/');
            var startChgStr = '';
            var endChgStr = '';
            startChgStr = startDateAr[2]+startDateAr[1]+startDateAr[0];
            endChgStr = endDateAr[2]+endDateAr[1]+endDateAr[0];

            if(startChgStr > endChgStr){

            	Common.alert('* Contract Commencement Date cannot bigger than Contract Expiry Date.');
                return false;
            }

        }

        // Added for EAR termination non national crisis, by Hui Ding 2020-10-20
        /* if($("#_prgId").val() == '8'){ // at verifying stage
        	 if($("#_msgStatus").val() == '6' ){ // if "reject"
        		 $("#_erlTerNonCrisisChk").prop("checked" , false); // reset Ear termination non national crisis flag to 0
        	 }
        } */


        //Remark
        if(null == $("#_resultRemark").val() || '' == $("#_resultRemark").val()){
            Common.alert('<spring:message code="sal.alert.msg.resultRemIsReq" />');
            return false;
        }

        if($("#_updSmsChk").is(":checked") == true && $("#_sendSmsSales").is(":checked") == false && $("#_sendSmsCody").is(":checked") == false){
        	Common.alert('Please select Sales or/and Cody to be send SMS.');
            return false;
        }

        var rowCount = AUIGrid.getRowCount(orderGridID);
        if(rowCount == 0) {
        	Common.alert('Order cannot be empty.');
            return false;
        }

        return true;
    }//Validation End

    function fn_intiField(){

        //Agr Type
        $("#_govAgTypeId").val('949');
        $("#_agrPeriodStart").val('');
        $("#_agrPeriodEnd").val('');
        $("#_resultRemark").val('');

    }

  //addcolum button hidden
    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){

        if(item.govAgMsgHasAttach == 'Yes'){
            return '';
        }else{
            return "edit-column";
        }
    }

    function fn_chgResultRemark(){
         //setSMSMessage(1 , $("#_resultRemark").val());
    }

    function  fn_removeRow(ordId){
        var originalOrdId = $("#_salesOrdId").val();
        if(originalOrdId == ordId){
            Common.alert('<spring:message code="sal.alert.msg.itmDisaRemvFromList" />');
        }else{
             AUIGrid.removeRow(orderGridID, "selectedIndex");
             AUIGrid.removeSoftRows(orderGridID);
             Common.alert('<spring:message code="sal.alert.msg.itmHasbeenRemvFromList" />');
        }

    }

    function fn_cancelAgm(){
    	//$("#_msgStatus").val('10');

        //Validation Success ()
        //$("#_hiddenUpdMsgStatus").val($("#_msgStatus").val());

        var data ={};
        //var param = AUIGrid.getGridData(orderGridID);
        //var gridData = GridCommon.getEditData(orderGridID);

        //upload attachment
        //var formData = Common.getFormData("_saveForm");
        //formData.append("updMsgId", $("#_updAgrId").val());

        data.form = $("#_saveForm").serializeJSON();
        //data.gridData = gridData;

        Common.ajax("POST", "/sales/ccp/cancelRentalAgrMtcEdit.do", data , function(result){
            //msg
            //result.msgLogSeq
            //$("#_upMsgId").val(result.msgLogSeq);
            //fn_disable_all();
            Common.alert("Agreement had cancelled.");
        });

    	$("#_close").click();
    }
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<form id="_newOrderAddForm">
    <input id="_addOrdId" name="addOrdId" type="hidden" >
</form>
<form  id="_searchForm">
    <input type="hidden" name="govAgId" value="${infoMap.govAgId}" id="_secGovAgId">
</form>

<%-- <input type="hidden" name="salesOrdId" id="_salesOrdId" value="${infoMap.govAgSalesOrdId}"> --%>
<input type="hidden" id="_prgId" value="${infoMap.govAgPrgrsId}">
<input type="hidden" id="_govAgStusId" value="${infoMap.govAgStusId}">
<input type="hidden" id="_editDocNo" value="${infoMap.govAgBatchNo}">
<input type="hidden" id = "_updErlTerNonCrisisChk" value="${infoMap.erlTerNonCrisisChk}">
<input type="hidden" id="_custName" value="${infoMap.name}">
<!-- from SalesMan (HP/CODY) -->
<input type="hidden" name="editSalesMemTypeId" id="_editSalesMemTypeId" value="${salesMan.memType}">
<input type="hidden" id="_editSalesManTelMobile" name="editSalesManTelMobile"  value="${salesMan.telMobile}">
<input type="hidden" id="_editCodyTelMobile" name="editCodyTelMobile"  value="${codyInfo.telMobile}">

<!-- changes flag -->
<input type="hidden" id="_msgStatusUpd" value="N">
<input type="hidden" id="_govAgTypeIdUpd"  value="N">
<input type="hidden" id="_govAgQtyUpd"  value="N">
<input type="hidden" id="_govAgStartDtUpd"  value="N">
<input type="hidden" id="_govAgEndDtUpd"  value="N">
<input type="hidden" id="_cowayTemplateUpd"  value="N">
<input type="hidden" id="_cntPeriodValueUpd"  value="N">
<input type="hidden" id="_draftRcvdUpd"  value="N">
<input type="hidden" id="_firstReviewUpd"  value="N">
<input type="hidden" id="_isSecReviewUpd"  value="N">
<input type="hidden" id="_secReviewUpd"  value="N">
<input type="hidden" id="_isThirdReviewUpd"  value="N">
<input type="hidden" id="_thirdReviewUpd"  value="N">
<input type="hidden" id="_isFirstFeedbackUpd"  value="N">
<input type="hidden" id="_firstFeedbackUpd"  value="N">
<input type="hidden" id="_isSecFeedbackUpd"  value="N">
<input type="hidden" id="_secFeedbackUpd"  value="N">
<input type="hidden" id="_isLatestFwdUpd"  value="N">
<input type="hidden" id="_latestFwdUpd"  value="N">
<input type="hidden" id="_isRfdUpd"  value="N">
<input type="hidden" id="_rfdUpd"  value="N">
<input type="hidden" id="_agrExecutionUpd"  value="N">
<input type="hidden" id="_agrFinalUpd"  value="N">
<input type="hidden" id="_sendStampingUpd"  value="N">
<input type="hidden" id="_receiveStampUpd"  value="N">
<input type="hidden" id="_courierUpd"  value="N">
<input type="hidden" id="_erlTerNonCrisisChkUpd"  value="N">

<header class="pop_header"><!-- pop_header start -->
<h1>Rental Agreement Status Update/View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" ><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<!--msg Hidden  -->
<input type="hidden" id="_upMsgId"  >
<form  method="get" id="_saveForm">

<input type="hidden" name="salesOrdId" id="_salesOrdId" value="${infoMap.govAgSalesOrdId}">

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" onclick="javascript: fn_resizeFun('agrInfo')"><spring:message code="sal.title.text.agrInfo" /></a></li>
   <li><a href="#" onclick="javascript: fn_resizeFun('order')"><spring:message code="sal.title.text.cntcOrds" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.agrInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td><span>${infoMap.govAgBatchNo}</span></td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td><span>${infoMap.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td>
    <select class="w100p" id="_govAgTypeId"  name="govAgTypeId">
        <option value="949">New Agreement</option>
        <option value="950">Renewal Agreement</option>
    </select>
    </td>
    <th scope="row">Date Created</th>
    <td><span>${infoMap.govAgCrtDt}</span></td>
</tr>
<c:if test="${!(infoMap.govAgStusId == '4' || infoMap.govAgStusId == '10')}">
	<tr>
	    <th scope="row"><spring:message code="sal.title.text.msgStatus" /></th>
	    <td>
	    <select class="w100p" id="_msgStatus" name="updMsgStatus"></select>
	    </td>
	</tr>
</c:if>

<tr>
    <th scope="row">No. of copies</th>
    <td><input type="text" id="_govAgQty" name="govAgQty" class="w100p" onkeyup="this.value=this.value.replace(/[^\d]/,'')"/>
    <%-- <span>${infoMap.govAgQty}</span> --%>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td><span>${infoMap.name1}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgss" /></th>
    <td><span>${infoMap.govAgPrgrsName}</span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span>${infoMap.userName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.renAgrStart" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date"   id="_govAgStartDt" name="govAgStartDt"/></p>
    </div><!-- date_set end -->
    <%-- <span>${infoMap.govAgStartDt}</span> --%>
    </td>
    <th scope="row"><spring:message code="sal.title.text.renAgrExpiry" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date"   id="_govAgEndDt" name="govAgEndDt"/></p>
    </div><!-- date_set end -->
    <%-- <span>${infoMap.govAgEndDt}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">Coway's Template</th>
    <td>
    <select class="w100p" id="_cowayTemplate" name="cowayTemplate">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.cntcAgrPeriod" /></th>
    <td>
    <select class="w100p" id="_cntPeriodValue" name="cntPeriodValue">
        <option value="0" selected>Choose One</option>
        <option value="12">12</option>
        <option value="24">24</option>
        <option value="36">36</option>
        <option value="48">48</option>
        <option value="60">60</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Received Customer's Draft /Draft sent to customer</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Customer Draft Received" placeholder="DD/MM/YYYY" class="j_date"   id="_draftRcvd" name="draftRcvd"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">1st Review</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"   id="_firstReview" name="firstReview"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Received 1st Feedback from Customer</th>
    <td>
    <select class="w100p" id="_isFirstFeedback" name="isFirstFeedback">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Customer First Feedback" placeholder="DD/MM/YYYY" class="j_date"   id="_firstFeedback" name="firstFeedback"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">2nd Review</th>
    <td>
    <select class="w100p" id="_isSecReview" name="isSecReview">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Second review" placeholder="DD/MM/YYYY" class="j_date"   id="_secReview" name="secReview"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Received 2nd Feedback from Customer</th>
    <td>
    <select class="w100p" id="_isSecFeedback" name="isSecFeedback">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Customer Second Feedback" placeholder="DD/MM/YYYY" class="j_date"   id="_secFeedback" name="secFeedback"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">3rd Review</th>
    <td>
    <select class="w100p" id="_isThirdReview" name="isThirdReview">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Third review" placeholder="DD/MM/YYYY" class="j_date"   id="_thirdReview" name="thirdReview"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Agreement Finalised</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Agreement finalised" placeholder="DD/MM/YYYY" class="j_date"   id="_agrFinal" name="agrFinal"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">RFD Required & Date Forward to Business Unit</th>
    <td>
    <select class="w100p" id="_isRfd" name="isRfd">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="RFD" placeholder="DD/MM/YYYY" class="j_date"   id="_rfd" name="rfd"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">RFD/Business Unit Approval Received</th>
    <td>
    <select class="w100p" id="_isLatestFwd" name="isLatestFwd">
        <option value="" selected>Choose One</option>
        <option value="1">YES</option>
        <option value="0">NO</option>
    </select>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Lastest fwd to other department" placeholder="DD/MM/YYYY" class="j_date"   id="_latestFwd" name="latestFwd"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Agreement Executed</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Agreement execution" placeholder="DD/MM/YYYY" class="j_date"   id="_agrExecution" name="agrExecution"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Sent for stamping</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Sent for stamping" placeholder="DD/MM/YYYY" class="j_date"   id="_sendStamping" name="sendStamping"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Received Stamp Certificate</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Received stamped" placeholder="DD/MM/YYYY" class="j_date"   id="_receiveStamp" name="receiveStamp"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Courier Out</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Courier out" placeholder="DD/MM/YYYY" class="j_date"   id="_courier" name="courier"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Contract Contains Early Termination Clause</th>
    <td>
        <input type="checkbox" id="_erlTerNonCrisisChk" name="erlTerNonCrisisChk"/>
    </td>
</tr>

<input type="hidden" id="_isErlTerNonCrisisChk" name="isErlTerNonCrisisChk">
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<!-- order start -->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.newOrder" /></h2>
</aside><!-- title_line end -->



<table class="type1" id="addOrd"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.newOrderNo" /><span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="" class="" style="width:100px" id="_inputConfirmNewOrder" name="inputConfirmNewOrder" maxlength="20"/>
        <p class="btn_sky"><a  id="_newOrderConfirm"><spring:message code="sal.title.text.confirmNewOrder" /></a></p>
        <p class="btn_sky"><a  id="_newOrderSearch"><spring:message code="sal.btn.search" /></a></p>
        <div style="float:right">
        <p class="btn_sky"><a  id="_newOrderRemove">Remove</a></p>
        </div>
    </td>
</tr>
</tbody>
</table>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="order_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article>
</section><!-- tap_wrap end -->

<!-- message log -->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.msgLog" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="msgLog_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<!-- result remark -->
<div id="_agrResult">

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.cntcAgrResult" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<input type="hidden" name="infomap" id="infomap" value="${infoMap}">

<input type="hidden" name="updAgrId" id="_updAgrId" value="${infoMap.govAgId}">
<input type="hidden" name="updPrgId" id="_updPrgId" value="${infoMap.govAgPrgrsId}">
<input type="hidden" name="hiddenUpdMsgStatus" id="_hiddenUpdMsgStatus">
<input type="hidden" name="updAgrNo" id="_updAgrNo" value="${infoMap.govAgBatchNo}">
<%-- <input type="hidden" id = "_updErlTerNonCrisisChk" value="${infoMap.erlTerNonCrisisChk}"> --%>

<!-- check box(sms) -->
<input type="hidden" name="isChkSms" id="_isChkSms">
<input type="hidden" name="isSendSales" id="_isSendSales">
<input type="hidden" name="isSendCody" id="_isSendCody">
<input type="hidden" name="hiddenUpdSmsMsg" id="_hiddenUpdSmsMsg">
<input type="hidden" name="hiddenSalesMobile" id="_hiddenSalesMobile">
<input type="hidden" name="hiddenCodyMobile" id="_hiddenCodyMobile">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.resultRem" /></th>
    <td colspan="3"><textarea cols="20" rows="5" id="_resultRemark" name="updResultRemark" onchange="javascript: fn_chgResultRemark()"></textarea></td>
</tr>
<tr>
    <th scope="row" rowspan="2"><spring:message code="sal.text.attachment" /></th>
    <td>
     <div class="auto_file2"><!-- auto_file start -->
        <input type="file" title="file add" style="width:300px" id="_fileName" name="fileName"/>
    </div><!-- auto_file end -->
    </td>
</tr>
<input type="hidden" id="_fileGroupKey" name="fileGroupKey">
<tr>
    <td colspan="2"><p><span class="red_text"><spring:message code="sal.text.fileExtension" /></span></p></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- SMS -->
<div id="_smsDiv">
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.smsInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="2">
    <label><input type="checkbox"  id="_updSmsChk"  /><span><spring:message code="sal.title.text.sendSmsQuest" /></span></label>
    <label><input type="checkbox"  id="_sendSmsSales"  /><span>Sales</span></label>
    <label><input type="checkbox"  id="_sendSmsCody"  /><span>Cody</span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.smsMsg" /></th>
    <td><textarea cols="20" rows="5" name="updSmsMsg" id="_updSmsMsg" ></textarea></td>
</tr>
<tr>
    <td colspan="2"><span id="_charCounter"><spring:message code="sal.title.text.totChars" /></span></td>
</tr>
</tbody>
</table><!-- table end -->

</div>
<ul>
    <li>
        <div ><a href="#" id="_btnCancel" ><font style="text-decoration: underline;">Cancel agreement</font></a></div>
        <div class="btn_blue2 center_btns"><a href="#" id="_btnEdit"><spring:message code="sal.btn.edit" /></a></div>
    </li>
    <%-- <li><p class="btn_blue2 center_btns"><a href="#" id="_btnEdit"><spring:message code="sal.btn.edit" /></a></p></li> --%>
    <li><p class="btn_blue2 center_btns"><a href="#" id="_btnSave"><spring:message code="sal.btn.save" /></a></p></li>
</ul>


</section><!-- search_table end -->

</div>
</form>
</section><!-- popBody end  -->
</div>