<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	$(document).ready(function() {


        doGetCombo('/common/selectCodeList.do', '487', '','hpStatus', 'S' , ''); //branchType


		$('#memBtn').click(function() {
            Common.popupDiv("/common/memberPop.do", $("#addForm").serializeJSON(), null, true, "test001");
        });
	});

	function fn_loadOrderSalesman(memId, memCode) {
        $("#itemMemCd").val(memCode);
    }

	//Mbo Item Save button
	function fn_ItemSavs(){
		if(fn_ValidMboItem()){
			Common.ajax("GET", "/organization/addLoyaltyHpUpload", $("#addForm").serializeJSON(), function(result) {
				if(result.code != "00"){
					Common.alert(result.message);
				}else{
                    Common.alert('<spring:message code="commission.alert.incentive.add.success"/>');
				}
            });
		}
	}

	//validation
	function fn_ValidMboItem(){

		if($("#itemMemCd").val() == null || $("#itemMemCd").val() ==""){
			Common.alert('<spring:message code="commission.alert.incentive.add.invalidMem"/>');
			$("#itemMemCd").focus();
			return false;
		}

		if($("#hpStatus").val() == null || $("#hpStatus").val() ==""){
            Common.alert('invalid Status');
            $("#hpStatus").focus();
            return false;
        }


		if($("#requestCreatStart").val() == null || $("#requestCreatEnd").val() ==""){
			 Common.alert('invalid date');
			 $("#requestCreatStart").focus();
            return false;
        }


		return true;
	}

</script>

<div id="popup_wrap" class="popup_wrap size_mid" ><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>LOYALTY HP PROGRAM UPLOAD -ADD UPLOAD BATCH</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height:150px;"><!-- pop_body start -->
	<form name="addForm" id="addForm">
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
				<col style="width:210px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><spring:message code='commission.text.search.memCode'/></th>
					<td><input type="text" id="itemMemCd" name="itemMemCd" maxlength="20">
					<a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
				</tr>
				<tr>
					<th scope="row">HP Status</th>
					<td>
					  <select  id="hpStatus" name="hpStatus" class="w100p">
					  </select>

					</td>
				</tr>
				<tr>
					<th scope="row">Date</th>
					<td>
					        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatStart" name="requestCreatStart"/></p>
				            <span>To</span>
				            <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="requestCreatEnd" name="requestCreatEnd"/></p>

					</td>
				</tr>
				<tr>
					<th scope="row">Period</th>
					<td>

					     <select  id="period" name="period" class="w100p">
					           <option value='Q1'> Q1 </option>
						       <option value='Q2'> Q2 </option>
						       <option value='Q3'> Q3 </option>
						       <option value='Q4'> Q4 </option>
                        </select>

					</td>
				</tr>

				<tr>
                    <th scope="row">Year</th>
                    <td>
                        <select  id="year" name="year" class="w100p">
                               <option value='2021'> 2021 </option>
                                 <option value='2022'> 2022 </option>
                                   <option value='2023'> 2023 </option>
                                     <option value='2024'> 2024 </option>
                                       <option value='2025'> 2025 </option>
                                         <option value='2026'> 2026 </option>
                                           <option value='2027'> 2027 </option>
                                             <option value='2028'> 2028 </option>
                                               <option value='2029'> 2029 </option>
                                               <option value='2030'> 2030 </option>
                                                   <option value='2031'> 2031 </option>

                        </select>
                    </td>
                </tr>
			</tbody>
		</table><!-- table end -->

		<input type="hidden" name="uploadId" id="uploadId " value="${uploadId}">
	</form>

	<ul class="center_btns">
		<li><p class="btn_blue"><a href="javascript:fn_ItemSavs();"><spring:message code='sys.btn.save'/></a></p></li>
	</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->