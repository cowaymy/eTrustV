<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var callLogTranID;
    var hcOrder = "${hcOrder}";
    var anoOrdNo = "${hcOrder.anoOrdNo}";
    var _addCllMsg = "Another order : <b>"+ anoOrdNo +"</b><br/>is also Add Call Log together.<br/>Do you want to continue?";

    function fn_saveValidation() {
        var msg = "";

        if ($("#callStatus").val() == '') {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Call Log Status' htmlEscape='false'/> </br>";
	    }

	    if ($("#callStatus").val() == 20) {
	        var rdcStk = $("#rdc").text();

	        if (rdcStk.trim() != '' || rdcStk != null) {
	            rdcStk = Number(rdcStk);
			} else {
			    rdcStk = Number(0);
			}

			if (rdcStk <= 0) {
			    msg += "* There is no available inventory in RDC to create installation order </br>";
			}

		    if ($("#requestDate").val() == '') {
		        msg += "* <spring:message code='sys.msg.necessary' arguments='Request Date' htmlEscape='false'/> </br>";
		    }

		    /* if(!$("input[name='verify']").prop("checked")){
		    	msg += "* <spring:message code='sys.msg.necessary' arguments='Verification' htmlEscape='false'/> </br>";
		    } */

		    /* var custMobileNo = $("#custMobileNo").val().replace(/[^0-9\.]+/g, "") ;
		    var chkMobileNo = custMobileNo.substring(0, 2);
		    if (chkMobileNo == '60'){
		    	  custMobileNo = custMobileNo.substring(1);
		    }
		    $("#custMobileNo").val(custMobileNo);
		    if ($("#custMobileNo").val().trim() == '' && $("#chkSMS").is(":checked")) {
		    	  msg += "* Please fill in customer mobile no </br> Kindly proceed to edit customer contact info </br>";
		    } */

		} else if ($("#callStatus").val() == 19) {
		    if ($("#recallDate").val() == '') {
		        msg += "* <spring:message code='sys.msg.necessary' arguments='Recall Date' htmlEscape='false'/> </br>";
		    }

        } else if ($("#callStatus").val() == 30) {
            if ($("#recallDate").val() == '') {
                msg += "* <spring:message code='sys.msg.necessary' arguments='Recall Date' htmlEscape='false'/> </br>";
            }
        }

	    if ($("#feedBackCode").val() == '') {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='Feedback Code' htmlEscape='false'/> </br>";
	    }

	    if (msg != "") {
	        Common.alert(msg);
	        return false;
	    }

	    return true;
	}

    function fn_saveConfirm() {
        if (fn_saveValidation()) {
            var msg = "";

            if ($("#callStatus").val() != "") {
                msg += "<spring:message code='service.title.CallLogStatus'/><b>" + " : " + $("#callStatus option:selected").text() + "</b></br>";
            }

            if ($("#callStatus").val() == "19" || $("#callStatus").val() == "30" ) {
                if ($("#recallDate").val() != "") {
			        msg += "<spring:message code='service.title.RecallDate'/><b>" + " : " + $("#recallDate").val() + "</b></br>";
                }
                if ($("#feedBackCode").val() != "") {
			        msg += "<spring:message code='service.title.FeedbackCode'/><b>" + " : " + $("#feedBackCode option:selected").text() + "</b></br>";
                }
                if ($("#remark").val() != "") {
                    msg += "<spring:message code='service.title.Remark'/><b>" + " : " + $("#remark").val() + "</b></br></br>";
                } else {
                    msg += "</br>";
                }

            } else {
                if ($("#requestDate").val() != "") {
                    msg += "<spring:message code='service.title.RequestDate'/><b>" + " : " + $("#requestDate").val() + "</b></br>";
			    }
			    if ($("#appDate").val() != "") {
                    msg += "<spring:message code='service.title.AppointmentDate'/><b>" + " : " + $("#appDate").val() + "</b></br>";
			    }
			    if ($("#CTSSessionCode").val() != "") {
                    msg += "<spring:message code='service.title.AppointmentSession'/><b>" + " : " + $("#CTSSessionCode").val() + "</b></br>";
			    }
			    if ($("#CTCode").val() != "") {
                    msg += "DT Code<b>" + " : " + $("#CTCode").val() + "</b></br>";
			    }
			    if ($("#feedBackCode").val() != "") {
                    msg += "<spring:message code='service.title.FeedbackCode'/><b>" + " : " + $("#feedBackCode option:selected").text() + "</b></br>";
			    }
			    if ($("#remark").val() != "") {
                    msg += "<spring:message code='service.title.Remark'/><b>" + " : " + $("#remark").val() + "</b></br></br>";
			    } else {
                    msg += "</br>";
			    }
			}

            if(anoOrdNo != '') {
                if('${hcOrder.anoOrdAppType}' == '5764' && ('${hcOrder.anoOrdCtgryCd}' == 'FRM' || '${hcOrder.anoOrdCtgryCd}' == 'ACO')){
                	Common.confirm(msg + _addCllMsg, fn_addCallSave);
                }else{
                	$("#anoOrdNo").val("");
                	Common.confirm(msg + "<spring:message code='sys.common.alert.save'/>", fn_addCallSave);
                }
            } else {
            	Common.confirm(msg + "<spring:message code='sys.common.alert.save'/>", fn_addCallSave);
            }
        }
    }

    function fn_addCallSave() {
    	console.log('${hcOrder.anoOrdNo}');
    	console.log("Form: " + $("#addCallForm #anoOrdNo").val());

        Common.ajax("POST", "/homecare/services/install/hcInsertCallResult.do", $("#addCallForm").serializeJSON(), function(result) {
        	Common.alert(result.message);

        	if(result.code == '00') { // success
        		fn_orderCallList();

                $("#hideContent").hide();
                $("#hideContent1").hide();
                $("#hideContent3").hide();
                $("#hideContent4").hide();
                $("#hiddenBtn").hide();
                $("#sav_div").attr("style", "display:none");

                //fn_callLogTransaction(); // REFRESH THE LIST
        	}
		});
    }


    function fn_callLogTransaction() {
        Common.ajax("GET", "/callCenter/getCallLogTransaction.do", $("#addCallForm").serialize(), function(result) {
            AUIGrid.setGridData(callLogTranID, result);

            if (result != "") {
                $('#veriremark').val(result[0].callRem);
            }
        });
    }

    // Ready
    $(document).ready(function() {
        callLogTranGrid();
        //fn_callLogTransaction();
        fn_start();

        console.log("qtytest");
        console.log('${orderRdcInCdc.raqty}');
        console.log('${anoRdcincdc.raqty}');

        $("#stock").change(function() {
            if ($("#stock").val() == 'B') {
                Common.ajax("POST", "/callCenter/changeStock.do", $("#addCallForm").serializeJSON(), function(result) {
                    Common.alert(result.message);

                    if (result.rdcincdc != null) {
		                $("#rdc").text(result.rdcincdc.raqty);
		                $("#rdcInCdc").text(result.rdcincdc.rinqty);
		                $("#cdc").text("0");
		            } else {
		                $("#rdc").text("0");
		                $("#rdcInCdc").text("0");
		                $("#cdc").text("0");
		            }
                });

            } else {
                Common.ajax("POST", "/callCenter/changeStock.do", $("#addCallForm").serializeJSON(), function(result) {
                    if (result.rdcincdc != null) {
                        $("#rdc").text(result.rdcincdc.raqty);
                        $("#rdcInCdc").text(result.rdcincdc.rinqty);
                        $("#cdc").text(result.rdcincdc.caqty);
                    } else {
                        $("#rdc").text("0");
                        $("#rdcInCdc").text("0");
                        $("#cdc").text("0");
                    }
                });
            }
        });

        $("#callStatus").change(function() {
            if ($("#callStatus").val() == "20") { // READY TO INSTALL
                $("#m1").show();
		        $("#m3").show();
		        $("#m4").show();
		        $("#m2").hide();

		    } else if ($("#callStatus").val() == "19") { // RECALL
		        $("#m1").show();
		        $("#m2").show();
		        $("#m4").show();
		        $("#m3").hide();

		    } else if ($("#callStatus").val() == "30") { // WAITING TO CANCEL
		        $("#m1").show();
		        $("#m4").show();
		        $("#m2").show();
		        $("#m3").hide();
		    }

	        $("#recallDate").val("");
	        $("#requestDate").val("");
	        $("#appDate").val("");
	        $("#CTgroup").val("");
	        $("#CTSSessionCode").val("");
	        $("#feedBackCode").val("");
	        $("#CTCode").val("");
	        $("#CTID").val("");
	        $("#CTName").val("");
	        $("#remark").val("");
	        $("#stock").val("A");
	    });


    });

    function fn_start() {
        $("#m2").hide();
        $("#m3").hide();
        $("#m4").hide();

        if ($("#callStatus").val() == "20") { // READY TO INSTALL
            $("#m1").show();
            $("#m3").show();
            $("#m4").show();
            $("#m2").hide();

        } else if ($("#callStatus").val() == "19") { // RECALL
            $("#m1").show();
            $("#m2").show();
            $("#m4").show();
            $("#m3").hide();

        } else if ($("#callStatus").val() == "30") { // WAITING TO CANCEL
            $("#m1").show();
            $("#m4").show();
            $("#m2").hide();
            $("#m3").hide();
        }

        if('${SESSION_INFO.userTypeId}' == 1 || '${SESSION_INFO.userTypeId}' == 2 || '${SESSION_INFO.userTypeId}' == 3 || '${SESSION_INFO.userTypeId}' == 7 ){
        	$("#hideContent3").hide();
        }

    }

    function callLogTranGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [
	        {dataField : "code",          headerText : '<spring:message code="service.grid.Status" />',                editable : false,          width : 100},
	        {dataField : "c1",              headerText : '<spring:message code="service.grid.RecallDate" />',          editable : false,          width : 100},
	        {dataField : "c2",              headerText : '<spring:message code="service.grid.ActionDate" />',         editable : false,          width : 130},
	        {dataField : "c9",              headerText : '<spring:message code="service.grid.Feedback" />',           editable : false,          width : 150},
	        {dataField : "c5",              headerText : '<spring:message code="service.grid.AssignCT" />',            editable : false,          style : "my-column",          width : 100},
	        {dataField : "callRem",       headerText : '<spring:message code="service.grid.Remark" />',              editable : false,          width : 180},
	        {dataField : "c3",              headerText : '<spring:message code="service.grid.KeyBy" />',                editable : false,          width : 180},
	        {dataField : "callCrtDt",      headerText : '<spring:message code="service.grid.KeyAt" />',                width : 180}
	    ];

	    var gridPros = {
	        usePaging : true,
	        pageRowCount : 20,
	        editable : false,
	        showStateColumn : true,
	        displayTreeOpen : true,
	        headerHeight : 30,
	        skipReadonlyColumns : true,
	        wrapSelectionMove : true,
	        showRowNumColumn : true
	    };
	    // create Grid
	    callLogTranID = AUIGrid.create("#grid_wrap_callLogList", columnLayout, gridPros);
    }

    function fn_doAllaction() {
        var ord_id = $("#salesOrdId").val();
        var vdte = $("#requestDate").val();
        var rdcStock = $("#rdcStock").text();


        if (rdcStock != '0') {
            Common.popupDiv("/homecare/services/install/hcAllocation.do", {ORD_ID : ord_id, S_DATE : vdte, TYPE : 'INS', ANO_ORD_NO : anoOrdNo, PROD_CAT : '${hcOrder.anoOrdCtgryCd}'}, null, true, '_doAllactionDiv');
        } else {
        	Common.alert("<spring:message code='service.msg.stock'/> ");
        }
    }

</script>

<div id="popup_wrap" class="popup_wrap">
	<!-- popup_wrap start -->
	<header class="pop_header">
	    <!-- pop_header start -->
	    <h1><spring:message code='service.title.NewCallLogResult' /></h1>
        <ul class="right_opt">
	    <li>
            <p class="btn_blue2">
                <a href="#none"><spring:message code='sys.btn.close' /></a>
            </p>
        </li>
	    </ul>
	</header>

    <!-- pop_header end -->
    <section class="pop_body">
        <!-- pop_body start -->
		<article class="acodi_wrap">
            <!-- acodi_wrap start -->
            <dl>
                <dt class="click_add_on on">
		            <a href="#none"><spring:message code='service.title.CallLogInformationTransaction' /></a>
                </dt>
                <dd>
                    <!-- table start -->
					<table class="type1">
						<caption>table</caption>
                            <colgroup>
                                <col style="width: 140px" />
							    <col style="width: *" />
							    <col style="width: 135px" />
							    <col style="width: *" />
                            </colgroup>
                        <tbody>
					    <tr>
					        <th scope="row"><spring:message code='service.title.CallLogType' /></th>
					        <td><span><c:out value="${orderCall.callTypeName}" /></span></td>
					        <th scope="row"><spring:message code='service.title.CreateDate' /></th>
					        <td><span><c:out value="${orderCall.crtDt}" /> </span></td>
					        <th scope="row"><spring:message code='service.title.CreateTime' /></th>
					        <td><span><c:out value="${orderCall.crtTm}"/> </span></td>
                        </tr>
					    <tr>
					        <th scope="row"><spring:message code='service.title.CallLogStatus' /></th>
                            <td><span><c:out value="${orderCall.callStusCode}" /></span></td>
					        <th scope="row"><spring:message code='service.title.UpdateDate' /></th>
					        <td><span><c:out value="${firstCallLog[0].callDt}" /> </span></td>
					        <th scope="row"><spring:message code='service.title.UpdateTime' /></th>
					        <td><span><c:out value="${firstCallLog[0].callTm}"/> </span></td>
                        </tr>
					    <tr>
                            <th scope="row"><spring:message code='service.title.WaitForCancel' /></th>
					            <c:if test="${orderCall.isWaitCancl == '0' }">
					                <td><span>No</span></td>
					            </c:if>
					            <c:if test="${orderCall.isWaitCancl == '1' }">
					                <td><span>Yes</span></td>
					            </c:if>
					        <th scope="row"><spring:message code='service.title.Creator' /></th>
					        <td><span><c:out value="${orderCall.crtUserId}" /></span></td>
					        <th scope="row">Bundle Number</th>
					        <td><span> <c:out value="${hcOrder.bndlNo}" /></span></td>
                        </tr>
                        <tr>
					        <th scope="row"><spring:message code='service.title.ProductToInstall' /></th>
					        <td colspan="3">
					           <span><c:out value="${orderCall.productCode}" /> - <c:out value="${orderCall.productName}" />
					           <c:if test = "${not empty anoProduct.stkCode}">
					               <br/><c:out value="${anoProduct.stkCode}" /> - <c:out value="${anoProduct.stkDesc}" />
					           </c:if>
					           </span>
					        </td>
					        <th scope="row">Order No</th>
					        <td>
                               <span><c:out value="${salesOrdNo}" />
                               <c:if test = "${not empty hcOrder.anoOrdNo}">
                                   <br/><c:out value="${hcOrder.anoOrdNo}" />
                               </c:if>
                               </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><spring:message code='service.title.RDCAvailableQty' /></th>
					        <td><span id="rdc"><c:out value="${orderRdcInCdc.raqty}" />
					        <c:if test = "${not empty anoRdcincdc.raqty}">
                                / <c:out value="${anoRdcincdc.raqty}" />
                            </c:if>
                            </span></td>
					        <th scope="row"><spring:message code='service.title.InTransitQty' /></th>
					        <td><span id="rdcInCdc"><c:out value="${orderRdcInCdc.rinqty}" /></span></td>
					        <th scope="row"><spring:message code='service.title.CDCAvailableQty' /></th>
					        <td>
					            <c:if test="${orderRdcInCdc.rdc== orderRdcInCdc.cdc }">
					                <span id="cdc">0</span>
					            </c:if>
					            <c:if test="${orderRdcInCdc.rdc != orderRdcInCdc.cdc }">
                                    <span id="cdc"><c:out value="${orderRdcInCdc.caqty}" /></span>
                                </c:if>
                        </tr>
                    </tbody>
                </table>
		        <!-- table end -->
                <article class="grid_wrap mt20">
                    <!-- grid_wrap start -->
	                <div id="grid_wrap_callLogList" style="width: 100%; height: 250px; margin: 0 auto;"></div>
                </article>
                <!-- grid_wrap end -->
            </dd>
            <dt class="click_add_on">
		        <a href="#none"><spring:message code='service.title.OrderFullDetails' /></a>
		    </dt>
		    <dd>
				<!------------------------------------------------------------------------------
				Order Detail Page Include START
				------------------------------------------------------------------------------->
				<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
				<!------------------------------------------------------------------------------
				 Order Detail Page Include END
				 ------------------------------------------------------------------------------->
            </dd>
        </dl>
    </article>
    <!-- acodi_wrap end -->

    <form action="#" id="addCallForm" autocomplete=off>
    <aside class="title_line mt20" id="hideContent3">
        <!-- title_line start -->
        <h2><spring:message code='service.title.DSCVerificationRemark' /></h2>
    </aside>
    <!-- title_line end -->

    <table class="type1" id="hideContent">
        <!-- table start -->
        <caption>table</caption>
		    <colgroup>
	            <col style="width: 130px" />
		        <col style="width: *" />
	        </colgroup>
        <tbody>
            <%-- <tr>
                <th scope="row"><spring:message code='service.title.verify' /></th>
                <td>
                <c:choose>
                    <c:when test= "${orderDetail.installationInfo.vrifyFlg == '1'}">
                        <input type = "checkbox" id="verify "name = "verify" value="1" checked disabled/>
                    </c:when>
                    <c:otherwise>
                        <input type = "checkbox" id="verify "name = "verify" value="1"/>
                    </c:otherwise>
                 </c:choose>
                 </td>
            </tr> --%>
	        <tr>
	            <th scope="row"><spring:message code='service.title.VerificationRemark' /></th>
	            <td><textarea cols="20" rows="5" id="veriremark" name="veriremark" >${orderDetail.installationInfo.vrifyRem}</textarea></td>
	        </tr>
        </tbody>
    </table>
    <!-- table end -->
    <aside class="title_line mt20" id="hideContent4">
    <!-- title_line start -->
        <h2><spring:message code='service.title.NewCallLogResult' /></h2>
    </aside>
    <!-- title_line end -->
		<input type="hidden" value="${orderCall.c4}" id="hiddenProductId" name="hiddenProductId" />
		<input type="hidden" value="${orderCall.callStusId}" id="hiddenCallLogStatusId" name="hiddenCallLogStatusId" />
		<input type="hidden" value="${callStusCode}" id="callStusCode" name="callStusCode" />
		<input type="hidden" value="${callStusId}" id="callStusId" name="callStusId" />
		<input type="hidden" value="${salesOrdId}" id="salesOrdId" name="salesOrdId" />
		<input type="hidden" value="${callEntryId}" id="callEntryId" name="callEntryId" />
		<input type="hidden" value="${salesOrdNo}" id="salesOrdNo" name="salesOrdNo" />
		<input type="hidden" value="${orderCall.rcdTms}" id="rcdTms" name="rcdTms" />
		<input type="hidden" value="${orderCall.callTypeId}" id="callTypeId" name="callTypeId" />
		<input type="hidden" value="${hcOrder.anoOrdNo}" id="anoOrdNo" name="anoOrdNo" />
		<input type="hidden" value="${orderCall.c1}" id="apptypeId" name="apptypeId" />
        <input type="hidden" value="${orderDetail.basicInfo.custType}" id="custType" name="custType" />

		<table class="type1" id="hideContent1">
            <!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
			</colgroup>
			<tbody>
			    <tr>
                    <th scope="row"><spring:message code='service.title.CallLogStatus' /><span name="m1" id="m1" class="must">*</span></th>
                    <td><select class="w100p" id="callStatus" name="callStatus">
			        <c:forEach var="list" items="${callLogSta}" varStatus="status">
			            <c:choose>
			                <c:when test="${list.code=='19' || list.code=='20' || list.code=='30'}">
			                    <c:choose>
			                        <c:when test="${list.code=='20'}">
			                            <option value="${list.code}" selected>${list.codeName}</option>
			                        </c:when>
			                        <c:otherwise>
			                            <option value="${list.code}">${list.codeName}</option>
			                        </c:otherwise>
			                    </c:choose>
                            </c:when>
                        </c:choose>
			        </c:forEach>
                    </select></td>
			        <th scope="row"><spring:message code='service.title.RecallDate' /><span name="m2" id="m2" class="must">*</span></th>
			        <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="recallDate" name="recallDate" /></td>
			        <th scope="row"><spring:message code='service.title.RequestDate' /><span name="m3" id="m3" class="must">*</span></th>
			        <td><input type="text" title="Request Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="requestDate" name="requestDate" onchange="javascript:fn_doAllaction()" /></td>
			        <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
			        <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" readonly="readonly" class="readonly j_dateHc w100p" id="appDate" name="appDate" /></td>
                </tr>
                <tr>
			        <th scope="row">DT Group</th>
			        <td><input type="text" title="" placeholder="DT Group" class="readonly w100p" readonly="readonly" id="CTgroup" name="CTgroup" /> </td>
			        <th scope="row"><spring:message code='service.title.AppointmentSessione' /></th>
			        <td><input type="text" title="" placeholder="<spring:message code='service.title.AppointmentSessione' />" readonly="readonly" id="CTSSessionCode" name="CTSSessionCode" class="readonly w100p" /></td>
			        <th scope="row"><spring:message code='service.title.FeedbackCode' /><span name="m4" id="m4" class="must">*</span></th>
			        <td colspan="3">
			            <select class="w100p" id="feedBackCode" name="feedBackCode">
				            <option value=""><spring:message code='service.title.FeedbackCode' /></option>
				            <c:forEach var="list" items="${callStatus}" varStatus="status">
				                <option value="${list.resnId}">${list.c1}</option>
	              			</c:forEach>
                        </select>
                    </td>
                </tr>
			    <tr>
                    <th scope="row">DT Code</th>
                    <td>
                        <div class="search_100p">
			                <!-- search_100p start -->
			                <input type="text" title="" placeholder="DT Code" class="readonly w100p" readonly="readonly" id="CTCode" name="CTCode" />
			                <input type="hidden" placeholder="" class="w100p" id="CTID" name="CTID" />
                        </div>
                        <!-- search_100p end -->
                    </td>
                    <th scope="row">DT Name</th>
                    <td colspan="3"><input type="text" title="" placeholder="DT Name" class="readonly w100p" readonly="readonly" id="CTName" name="CTName" /></td>
                    <th scope="row">Grade A - B</th>
                    <td colspan="1">
                        <select class="w100p" id="stock" name="stock">
			                <option value="A">A</option>
			                <option value="B">B</option>
                        </select>
                    </td>
                </tr>
            <%--      <tr>
				     <th scope="row">Mobile<span name="m2" id="m2" class="must">*</span></th>
				      <td colspan="3">
				          <input type="text" title="" value ="${orderDetail.installationInfo.instCntTelM}" placeholder="Mobile No" id="custMobileNo" name="custMobileNo" />
				          <span>SMS</span><input type="checkbox" id="chkSMS" name="chkSMS" checked>
				          <br><br>
				          <span>Total SMS Count :</span><input type="text" id="smsCount" name="smsCount" class="readonly" readonly="readonly" style="width:10%;"> 
				     </td>
				     <th></th><td colspan="3"></td>
				</tr> --%>
			    <tr>
                    <th scope="row"><spring:message code='service.title.Remark' /></th>
                    <td colspan="7"><textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />" id="remark" name="remark"></textarea></td>
                </tr>
            </tbody>
        </table>
		<!-- table end -->
    </form>
    <div id='sav_div'>
	    <ul class="center_btns" id="hiddenBtn">
		    <li>
	            <p class="btn_blue2 big"><a href="#none" onclick="fn_saveConfirm()">Save</a></p>
	        </li>
		    <li>
	            <p class="btn_blue2 big"><a href="#none">Clear</a></p>
	        </li>
	    </ul>
    </div>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
