<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  
   var memConfirmGridID; // Membership Confirm List Grid
   
   $(document).ready(function(){
	   
	   //Create Grid
	   creatememConfirmGrid();
	   
	   //Get ComboBox
	   doGetCombo('/sales/ccp/getBranchCodeList', '', '','_keyInBranch', 'M' , 'f_multiCombo'); //Branch
	   doGetCombo('/sales/ccp/getReasonCodeList', '', '','_reasonCode', 'M' , 'f_multiCombo'); //Reason
	   doGetCombo('/common/selectCodeList.do', '8', '','_custType', 'S' , ''); //Cust Type
	   
	   //Search
	   $("#_btnSearch").click(function(){
		   
		   Common.ajax("GET", "/sales/ccp/selectCcpRentListSearchList", $("#searchForm").serialize(), function(result) {
	            AUIGrid.setGridData(memConfirmGridID, result);
	        });
		   
	   });
	   
	   
	   // 셀 더블클릭 이벤트 바인딩
	   AUIGrid.bind(memConfirmGridID, "cellDoubleClick", function(event){
	       
		   $("#_cnfmCntrctId").val(event.item.cnfmCntrctId);
		   console.log(event.item.cnfmCntrctId);
	       Common.popupDiv("/sales/ccp/selectCcpRentDetailVeiwPop.do", $("#detailForm").serializeJSON());
	   });
	   
	   
	   //Confirm Result
	   $("#_confirmBtn").click(function() {
		   
		   //Validation
		   var selectedItem = AUIGrid.getSelectedItems(memConfirmGridID);
		
		   if(selectedItem.length <= 0){
			   Common.alert('<spring:message code="sal.alert.msg.noRentMemSel" />');
			   return;
		   }
		   
		   if(selectedItem[0].item.cnfmStusId != 44 && selectedItem[0].item.cnfmStusId != 1){
			   Common.alert('<spring:message code="sal.alert.msg.rentMemNotActPenStatus" />');
			   return;
		   }
		   
		   //PopUp
		   $("#_cnfmCntrctId").val(selectedItem[0].item.cnfmCntrctId);
		   $("#_srvCntrctOrdId").val(selectedItem[0].item.srvCntrctOrdId);
		   $("#_srvCntrctId").val(selectedItem[0].item.srvCntrctId);
		   Common.popupDiv("/sales/ccp/selectCcpConfirmResultPop.do", $("#detailForm").serializeJSON(), null , true , '_editDiv');
		   
	   });
   });//Document Ready Func End
   
   //TODO 미개발
   function fn_underDevelop(){
       Common.alert('The program is under development.');
   }
   
   $.fn.clearForm = function() {
       return this.each(function() {
           var type = this.type, tag = this.tagName.toLowerCase();
           if (tag === 'form'){
               return $(':input',this).clearForm();
           }
           if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
               this.value = '';
           }else if (type === 'checkbox' || type === 'radio'){
               this.checked = false;
           }else if (tag === 'select'){
               this.selectedIndex = -1;
           }
       });
   };
  
   function creatememConfirmGrid(){
	// Confirm List Column
       var confirmColumnLayout = [ 
            {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordNop" />', width : '10%'}, 
            {dataField : "srvCntrctRefNo", headerText : '<spring:message code="sal.title.text.scsNop" />', width : '10%'},
            {dataField : "name", headerText : '<spring:message code="sal.text.keyInBranch" />', width : '10%'}, 
            {dataField : "keyAtBy", headerText : '<spring:message code="sal.title.text.keyAtBy" />', width : '10%'},
            {dataField : "name1", headerText : '<spring:message code="sal.text.custName" />', width : '10%'},
            {dataField : "code", headerText : '<spring:message code="sal.title.text.callLogStus" />', width : '10%'},
            {dataField : "resnDesc", headerText : '<spring:message code="sal.title.text.feedback" />', width : '10%'},
            {dataField : "cnfmRem", headerText : '<spring:message code="sal.title.remark" />', width : '20%'},
            {dataField : "updateAtBy", headerText : '<spring:message code="sal.title.text.updAtBy" />', width : '10%'},
            {dataField : "cnfmCntrctId", visible : false},
            {dataField : "srvCntrctOrdId", visible : false},
            {dataField : "cnfmStusId", visible : false}, 
            {dataField : "srvCntrctId", visible : false}
          ];
       
       //그리드 속성 설정
       var gridPros = {
               
               usePaging           : true,         //페이징 사용
               pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
               editable            : false,            
               fixedColumnCount    : 1,            
               showStateColumn     : true,             
               displayTreeOpen     : false,            
    //           selectionMode       : "singleRow",  //"multipleCells",            
               headerHeight        : 30,       
               useGroupingPanel    : false,        //그룹핑 패널 사용
               skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
               wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
               showRowNumColumn    : true
           };
       
       memConfirmGridID = GridCommon.createAUIGrid("confirm_grid_wrap", confirmColumnLayout,'', gridPros);   // Confirm List
	   
   }
   
   // 조회조건 combo box
   function f_multiCombo(){
       $(function() {
           $('#_keyInBranch').change(function() {
           
           }).multipleSelect({
               selectAll: true, // 전체선택 
               width: '80%'
           });
           $('#_reasonCode').change(function() {
               
           }).multipleSelect({
               selectAll: true, // 전체선택 
               width: '80%'
           });
          
       });
   }

</script>

	<!-- wrap start -->
	<section id="content">
		<!-- content start -->
		<ul class="path">
			<li><img
				src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
				alt="Home" /></li>
			<li>Sales</li>
			<li>Order list</li>
		</ul>

		<aside class="title_line">
			<!-- title_line start -->
			<p class="fav">
				<a href="#" class="click_add_on">My menu</a>
			</p>
			<h2><spring:message code="sal.title.text.rentMemConfList" /></h2>
			<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
				<li><p class="btn_blue">
                       <a href="#" id="_confirmBtn"><spring:message code="sal.title.text.confirmResult" /></a> 
                   </p></li>
                </c:if>   
                <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue">
                        <a href="#" id="_btnSearch"><span class="search"></span><spring:message code="sal.btn.search" /></a>
                    </p></li>
                 </c:if>   
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a>
					</p></li>
			</ul>
		</aside>
		<!-- title_line end -->


		<section class="search_table">
			<!-- search_table start -->
			<form id="detailForm">
				<input type="hidden" name="cnfmCntrctId" id="_cnfmCntrctId">
				<input type="hidden" name="srvCntrctOrdId" id="_srvCntrctOrdId">
				<input type="hidden" name="srvCntrctId" id="_srvCntrctId">
			</form>
			<form id="searchForm">

				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 180px" />
						<col style="width: *" />
						<col style="width: 180px" />
						<col style="width: *" />
						<col style="width: 180px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message code="sal.title.text.memRefNo" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								name="refNo" /></td>
							<th scope="row"><spring:message code="sal.title.text.keyInDate" /></th>
							<td>
								<div class="date_set w100p">
									<!-- date_set start -->
									<p>
										<input type="text" title="Create start Date"
											placeholder="DD/MM/YYYY" class="j_date" name="sDate" />
									</p>
									<span><spring:message code="sal.title.to" /></span>
									<p>
										<input type="text" title="Create end Date"
											placeholder="DD/MM/YYYY" class="j_date" name="eDate" />
									</p>
								</div>
								<!-- date_set end -->
							</td>
							<th scope="row"><spring:message code="sal.title.text.membershipStus" /></th>
							<td><select class="multy_select w100p" multiple="multiple"
								name="memShipStatus">
									<option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
									<option value="44" selected="selected"><spring:message code="sal.text.pending" /></option>
									<option value="5"><spring:message code="sal.combo.text.approv" /></option>
									<option value="10"><spring:message code="sal.combo.text.cancelled" /></option>
							</select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.title.text.ordNop" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								name="salesOrdNo" /></td>
							<th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
							<td><select class="multy_select w100p" multiple="multiple"
								id="_keyInBranch" name="keyInBranch"></select></td>
							<th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								name="nric" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.combo.text.sortingByCustomerName" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								name="custName" /></td>
							<th scope="row"><spring:message code="sal.text.custType" /></th>
							<td><select class="w100p" id="_custType" name="custType"></select>
							</td>
							<th scope="row"><spring:message code="sal.title.text.region" /></th>
							<td><select class="w100p" name="region">
									<option disabled="disabled" selected="selected"><spring:message code="sal.title.text.region" /></option>
									<option value="651"><spring:message code="sal.combo.text.central" /></option>
									<option value="652"><spring:message code="sal.combo.text.northern" /></option>
									<option value="653"><spring:message code="sal.combo.text.southern" /></option>
									<option value="654"><spring:message code="sal.combo.text.centralA" /></option>
									<option value="655"><spring:message code="sal.combo.text.centralB" /></option>
							</select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.memFBcode" /></th>
							<td><select class="multy_select w100p" multiple="multiple"
								id="_reasonCode" name="reasonCode"></select></td>
							<th scope="row"><spring:message code="sal.title.text.lastUpdUser" /></th>
							<td><input type="text" title="" placeholder="" class="w100p"
								name="updUser" /></td>
							<th scope="row"></th>
							<td></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->

<%-- 				<aside class="link_btns_wrap">
					<!-- link_btns_wrap start -->
					<p class="show_btn">
						<a href="#"><img
							src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
							alt="link show" /></a>
					</p>
					<dl class="link_list">
						<dt>Link</dt>
						<dd>
							<ul class="btns">
								<li><p class="link_btn">
										<a href="#" onclick="javascript : fn_underDevelop()">menu1</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu2</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu3</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu4</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">Search Payment</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu6</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu7</a>
									</p></li>
								<li><p class="link_btn">
										<a href="#">menu8</a>
									</p></li>
							</ul>
							<ul class="btns">
							</ul>
							<p class="hide_btn">
								<a href="#"><img
									src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
									alt="hide" /></a>
							</p>
						</dd>
					</dl>
				</aside>
				<!-- link_btns_wrap end --> --%>

			</form>
		</section>
		<!-- search_table end -->

		<section class="search_result">
			<!-- search_result start -->

			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="confirm_grid_wrap"
					style="width: 100%; height: 480px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->

		</section>
		<!-- search_result end -->
	</section>
	<!-- content end -->
</body>
</html>