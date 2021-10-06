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
        		var dob = '${custInfo.codeName1}' == "Individual" ? nricToDob(nric) : null;
                var pattern = new RegExp(/[~`!#$%\^&*+=\-\[\]\\';,/{}.|\\":<>\?]/);

                var nricObj = {nric:nric};
                var custObj = {custId:'${custInfo.custId}', action:action, nric:nric, dob:dob, rcdTms:'${custInfo.updDt}'};

                Common.ajaxSync("GET", "/sales/customer/validCustStatus.do", custObj, function(result) {
                    if(result != null){
                    	var isValid = result.isvalid == null ? true : false;
                    	var valid = true;

                    	if(result.crtDtDiff > 9999){
                            Common.alert("Exceed allowable period" + DEFAULT_DELIMITER + "Exceed allowable period.<br/>Kindly refer to IT department");
                            return;
                        }else{
                        	if(action == "EDIT"){
                                if (FormUtil.isEmpty(nric)) {
                                    Common.alert('<spring:message code="sal.alert.msg.plzKeyInCustNricComNo" />');
                                    valid = false;
                                }else if(!isValid){
                                	Common.alert('Edit Customer NRIC disallowed.<br/>Customer is having cancelled order(s) or order(s) pending for CCP');
                                	valid = false;
                                }else{
                                    if (pattern.test(nric)) {
                                        Common.alert("Please ensure NRIC does not contains special characters<br/>");
                                        valid = false;
                                    }

                                    if('${custInfo.codeName1}' == "Individual"){
                                        var lastDigit = parseInt(nric.charAt(nric.length - 1));
                                        if (lastDigit != null) {

                                            if ('${custInfo.gender}' == "F") {
                                              if (lastDigit % 2 != 0) {
                                                Common.alert('<spring:message code="sal.alert.msg.invalidNric" />');
                                                valid = false;
                                              }
                                            } else {
                                              if (lastDigit % 2 == 0) {
                                                Common.alert('<spring:message code="sal.alert.msg.invalidNric" />');
                                                valid = false;
                                              }
                                            }
                                          }
                                    }

                                    Common.ajaxSync("POST", "/sales/customer/nricDupChk.do", nricObj, function(result){
                                        if(result != null){
                                            Common.alert('<spring:message code="sal.alert.msg.existCustomerBrCustId" />' + result.custId);
                                            valid = false;
                                        }
                                    });
                                }
                            }else if(action == "DEACTIVE" && !isValid){
                            	Common.alert("Deactivate not allowed.<br/>Customer is having order(s) in ACT/COM status.");
                            	valid = false;
                            }

                        	if(valid){
                            	Common.confirm(action + ":" + " Cust ID - " + '${custInfo.custId}' +"? ", function(){
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

    function nricToDob(nric){
    	let dob = "";

    	let year  = nric.substr(0, 2);
        let month = nric.substr(2, 2);
        let day   = nric.substr(4, 2);

        if(year <= 99){
            year = "19" + year;
        }else{
            year = "20" + year;
        }

        dob = day + "/" + month + "/" + year;

        return dob;
    }

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
    <input type="hidden" id="_editDob" name="_editDob"/>
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
	                     <td><input type="text" title="_editNric" id="_editNric" name="_editNric"/></td>
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