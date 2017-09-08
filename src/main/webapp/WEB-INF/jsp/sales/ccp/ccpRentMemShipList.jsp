<script type="text/javascript">
   
   var memConfirmGridID; // Membership Confirm List Grid
   
   $(document).ready(function() {
	   
	   creatememConfirmGrid();
	   
	   doGetCombo('/sales/ccp/getBranchCodeList', '', '','_keyInBranch', 'M' , 'f_multiCombo'); //Branch
	   doGetCombo('/sales/ccp/getReasonCodeList', '', '','_reasonCode', 'M' , 'f_multiCombo'); //Reason
	   doGetCombo('/common/selectCodeList.do', '8', '','_custType', 'S' , ''); //Cust Type
	   
	   //Search
	   $("#_btnSearch").click(function() {
		   
		   Common.ajax("GET", "/sales/ccp/selectCcpRentListSearchList", $("#searchForm").serialize(), function(result) {
	            AUIGrid.setGridData(memConfirmGridID, result);
	        });
		   
	   });
	   
   });

   //
   function creatememConfirmGrid(){
	// Confirm List Column
       var confirmColumnLayout = [ 
            {dataField : "salesOrdNo", headerText : "Order No.", width : '10%'}, 
            {dataField : "srvCntrctRefNo", headerText : "SCS No.", width : '10%'},
            {dataField : "name", headerText : "Key-In Branch", width : '10%'}, 
            {dataField : "keyAtBy", headerText : "Key At(By)", width : '10%'},
            {dataField : "name1", headerText : "Customer Name", width : '10%'},
            {dataField : "code", headerText : "Call Log Status", width : '10%'},
            {dataField : "resnDesc", headerText : "Feedback", width : '10%'},
            {dataField : "cnfmRem", headerText : "Remark", width : '20%'},
            {dataField : "updateAtBy", headerText : "Update At(By)", width : '10%'},
            {dataField : "cnfmCntrctId", visible : false}
          ];
       
       //그리드 속성 설정
       var gridPros = {
               
               usePaging           : true,         //페이징 사용
               pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
               editable            : false,            
               fixedColumnCount    : 1,            
               showStateColumn     : true,             
               displayTreeOpen     : false,            
               selectionMode       : "singleRow",  //"multipleCells",            
               headerHeight        : 30,       
               useGroupingPanel    : false,        //그룹핑 패널 사용
               skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
               wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
               showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
               noDataMessage       : "No order found.",
               groupingMessage     : "Here groupping"
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

<div id="wrap"><!-- wrap start -->
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Rental Membership Confirmation List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" id="_btnSearch"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Membership Ref No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="refNo"/></td>
    <th scope="row">Key In Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="sDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Memberhsip Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="memShipStatus">
        <option value="1" selected="selected">Active</option>
        <option value="44" selected="selected">Pending</option>
        <option value="5">Approved</option>
        <option value="10">Cancelled</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Order No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="salesOrdNo"/></td>
    <th scope="row">Key-In Branch</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_keyInBranch" name="keyInBranch"></select>
    </td>
    <th scope="row">NRIC/Company No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="nric" /></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="custName"/></td>
    <th scope="row">Customer Type</th>
    <td>
    <select class="w100p" id="_custType" name="custType"></select>
    </td>
    <th scope="row">Region</th>
    <td>
    <select class="w100p" name="region">
        <option  disabled="disabled" selected="selected">region</option>
        <option value="651">Central</option>
        <option value="652">Northern</option>
        <option value="653">Southern</option>
        <option value="654">Central A</option>
        <option value="655">Central B</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Membership F/B Code</th>
    <td>
    <select class="multy_select w100p" multiple="multiple"  id="_reasonCode" name="reasonCode"></select>
    </td>
    <th scope="row">Last Update User</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="updUser"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="confirm_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
</section><!-- content end -->
</div><!-- wrap end -->
</body>
</html>