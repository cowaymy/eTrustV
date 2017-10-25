
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">

var  gridID;
var  detailGridID;



$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    createDetailAUIGrid();
    
   // doGetCombo('/common/selectCodeList.do', '45', '','comBranchType', 'S' , ''); 
    
    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
        console.log(event.rowIndex);
        fn_selectDetailListAjax(AUIGrid.getCellValue(gridID, event.rowIndex, "reqstNo"))
    });
   
    AUIGrid.bind(gridID, "cellClick", function(event) {
        console.log(event.rowIndex);
        reqstNo = AUIGrid.getCellValue(gridID, event.rowIndex, "reqstNo");
        brnchType = AUIGrid.getCellValue(gridID, event.rowIndex, "brnchType");
    });
    
    fn_keyEvent();
    
});



function fn_keyEvent(){
	
    $("#SRV_CNTRCT_PAC_CODE").keydown(function(key)  {
            if (key.keyCode == 13) {
            	fn_mainSelectListAjax();
            }
     });
}





function createAUIGrid() {
   
	var columnLayout = [
                          { dataField : "reqstNo", headerText  : "TCR No",    width : 100 ,editable : false},
                          { dataField : "brnchName", headerText  : "Branch Type",width : 200 ,editable       : false},
                          { dataField : "reqstDt", headerText  : "Request Date",  width  : 100, dataType : "date", formatString : "dd/mm/yyyy" },
                          { dataField : "reqstUserId",       headerText  : "Requester",  width  : 100},
                          { dataField : "cnfmStusName",     headerText  : "Status",  width  :100},
                        /*   { dataField : "areaId",     headerText  : "areaId",  width  :100},
                          { dataField : "codyBrnchCode",     headerText  : "",  width  :100},
                          { dataField : "codyMangrUserId",     headerText  : "",  width  :100},
                          { dataField : "brnchType",     headerText  : "",  width  :100} */
                           
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    
    
    

function createDetailAUIGrid() {
        
        var columnLayout = [
                           
                            { dataField : "areaId", headerText  : "Area ID",    width : 100,  editable : false},
                            { dataField : "area", headerText  : "Area",width : 150,  editable: false },
                            { dataField : "city",   headerText  : "City",  width          : 100,   editable       : false},
                            { dataField : "postcode", headerText  : "Postal Code ",  width   : 100, editable       : false},
                            { dataField : "state",headerText  : "State",  width          : 100,   editable       : false },
                            { dataField : "branchCode",         headerText  : "CDB / DSC",   width          : 120,     editable       : false  },
                            { dataField : "manager",  headerText  : "Cody Manager / CT Sub Grp",   width          : 200,     editable       : false  }

       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        detailGridID = GridCommon.createAUIGrid("detail_list_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    



//리스트 조회.
function fn_mainSelectListAjax() {        
Common.ajax("GET", "/organization/territory/selectList", $("#sForm").serialize(), function(result) {
      console.log(result);
      AUIGrid.setGridData(gridID, result);
   });
}



//리스트 조회.
function fn_selectDetailListAjax(reqstNo) {        
	
  var selectedItems = AUIGrid.getSelectedItems(gridID);
  
  if(selectedItems.length <= 0 ){
        Common.alert("There Are No selected Items.");
        return ;
  }
  
  console.log(selectedItems[0]);
  
  Common.ajax("GET", "/organization/territory/selectDetailList", { reqstNo: reqstNo}, function(result) {
           
    console.log(result);
    AUIGrid.setGridData(detailGridID, result);
 });
   
}
 

function fn_Clear(){
	
    $("#comBranchType").val(""); 
    $("#REQST_NO").val("");
    $("#REQST_USER_ID").val("");
    $("#REQST_DT").val("");
}



function fn_New(){
    Common.popupDiv("/organization/territory/territoryNew.do" ,null, null , true , '_NewAddDiv1');
}

function fn_Comfirm() {
    Common.ajax("GET", "/organization/territory/comfirmTerritory.do", { reqstNo: reqstNo, brnchType : brnchType }, function(result) {
    	Common.alert(result.message);
    });
}


function fn_Cancel(){
    alert('fn_Cancel');
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Organization</li>
	<li>Territory Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Territory Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_mainSelectListAjax()"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="sForm" >

<aside class="title_line"><!-- title_line start -->
<h4>Assign Info</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:90px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Branch Type<span class="must">*</span></th>
	<td>
		<select class="multy_select w100p" multiple="multiple" id="comBranchType" name="comBranchType">
		   <option value="42">Cody Branch</option>
          <option value="43">Dream Service Center</option>
		</select>
	</td>
	<th scope="row">Assign Request Code</th>
	<td><input type="text" title="" placeholder="Assign Request Code" class="w100p" id="requestNo" name="requestNo" /></td>
	<th scope="row">Requester</th>
	<td>
		 <input type="text" title="" placeholder="Requester" class="w100p" id="requestUserId" name="requestUserId"  />
	</td>
	<th scope="row">Request Date</th>
	<td>
		<input type="text" title="기준년월" class="j_date w100p" id="requestDt" name="requestDt"  placeholder="DD/MM/YYYY" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<%-- <dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#">Magic Address Download</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl> --%>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="javasclipt:fn_Comfirm()">Comfirm</a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javasclipt:fn_Cancel()">Cancel</a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javasclipt:fn_New()">New</a></p></li>
	
</ul>

<aside class="title_line"><!-- title_line start -->
<h4>Information Display</h4>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="list_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h4>Detail Information</h4>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="detail_list_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

