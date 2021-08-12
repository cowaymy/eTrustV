<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var actData= [{"codeId": "EDIT","codeName": "Edit"},{"codeId": "DEACTIVE","codeName": "Deactivate"}];

    $(document).ready(function(){
    	$('#view_custId').text('${custInfo.custId}');
    	$('#view_custIc').text('${custInfo.nric}');
        doDefCombo(actData, '' ,'_action', 'S', '');

        $('#_action').change(function(event) {
            var action = $('#_action').val().trim();

            if(action == 'EDIT'){
                $("#editNric").show();
            }else{
            	$("#editNric").hide();
            }
        });

        $('#_btnEditSave').click(function() {

        	var action = $("#_action").val();

        	if(action == ""){
        		Common.alert("Please select an action");
        	}else{

        		var nric = $('#_editNric').val().trim();
                var pattern = new RegExp(/[~`!#$%\^&*+=\-\[\]\\';,/{}.|\\":<>\?]/);

                var nricObj = {nric:nric};
                var custObj = {custId:'${custInfo.custId}', action:action, nric:nric, rcdTms:'${custInfo.updDt}'};

                Common.ajaxSync("GET", "/sales/customer/validCustStatus.do", custObj, function(result) {
                    if(result != null){
                    	var isValid = result.isvalid == null ? true : false;

                    	if(result.crtDtDiff > 9999){
                            Common.alert("Exceed allowable period" + DEFAULT_DELIMITER + "Exceed allowable period.<br/>Kindly refer to IT department");
                            return;
                        }else{
                        	if(action == "EDIT" && !isValid){
                                if (FormUtil.isEmpty(nric)) {
                                    Common.alert('<spring:message code="sal.alert.msg.plzKeyInCustNricComNo" />');
                                    return;
                                }else if(!isValid){
                                	Common.alert('Edit Customer NRIC disallowed.<br/>Customer is having cancelled order(s) or order(s) pending for CCP');
                                    return;
                                }else{
                                    if (pattern.test(nric)) {
                                        Common.alert("Please ensure NRIC does not contains special characters<br/>");
                                        return;
                                    }

                                    if('${custInfo.codeName1}' == "Individual"){
                                        var lastDigit = parseInt(nric.charAt(nric.length - 1));
                                        if (lastDigit != null) {
                                              if ('${custInfo.gender}' == "F") {
                                                if (lastDigit % 2 != 0) {
                                                  Common.alert('<spring:message code="sal.alert.msg.invalidNric" />');
                                                  return;
                                                }
                                              } else {
                                                if (lastDigit % 2 == 0) {
                                                  Common.alert('<spring:message code="sal.alert.msg.invalidNric" />');
                                                  return;
                                                }
                                              }
                                          }
                                    }

                                    Common.ajaxSync("POST", "/sales/customer/nricDupChk.do", nricObj, function(result){
                                        if(result != null){
                                            Common.alert('<spring:message code="sal.alert.msg.existCustomerBrCustId" />' + result.custId);
                                            return;
                                        }
                                    });
                                }
                            }else if(action == "DEACTIVE" && !isValid){
                            	Common.alert("Deactivate not allowed.<br/>Customer is having order(s) in ACT/COM status.");
                            	return;
                            }else{
                            	Common.confirm(action + ":" + " Cust ID - " + '${custInfo.custId}' +"? ", function(){
                            		console.log(custObj);
                                    Common.ajax("POST","/sales/customer/updateCustStatus.do",custObj,
                                       function(result){ // Success
                                    	Common.alert(result.message);
                                        $("#btnClose").click();
                                        fn_selectPstRequestDOListAjax();
                                       },
                                       function(jqXHR, textStatus, errorThrown){ // Error
                                           Common.alert("Fail : " + jqXHR.responseJSON.message);
                                       }
                                    )
                                });
                            }
                        }
                    }
                });
        	}

        });

    });

</script>

<div class="popup_wrap size_mid" id="editDeact_wrap">
    <!-- pop_header start -->
    <header class="pop_header" id="upd_pop_header">
        <h1>Edit/Deactivate Customer</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="btnClose" href="#">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="updDeactForm" id="updDeactForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:250px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
	                <tr>
	                    <th scope="row"><spring:message code="sal.text.customerId" /></th>
	                    <td>${custInfo.custId}</td>
	                </tr>
	                <tr>
                        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
                        <td>${custInfo.nric}</td>
                    </tr>
	                <tr>
	                     <th scope="row"><spring:message code="sal.title.text.action" /><span class="must">*</span></th>
	                     <td><select class="mr5" id="_action" name="_action"></select></td>
	                 </tr>
	                 <tr id="editNric" style="display: none;">
	                     <th scope="row">New <spring:message code="sal.title.text.nricCompNo" />
	                           <span class="must">*</span>
	                     </th>
	                     <td><input type="text" title="_editNric" id="_editNric" name="_editNric"</td>
	                 </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="_btnEditSave" href="#">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>