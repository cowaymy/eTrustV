<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var assignGrid;
var rosCallGrid;

var companyList = [];
var agentList = [];

//ROS Call 화면에서 사용...
var gridPros = {
        
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
    //    selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        noDataMessage       : "No Ros Call found.",
        groupingMessage     : "Here groupping"
};


$(document).ready(function(){
	
    //Application Type
    CommonCombo.make("appType", "/common/selectCodeList.do", {groupCode : '10'}, '66', 
    		{
		        id: "codeId",
		        name:"codeName",
		        isShowChoose: false 
		      });
    //orderStatus
    CommonCombo.make('orderStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 27} , '4', 
    		{
		    	id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.    
		        isShowChoose: false
		    });
    //rentalStatus
    CommonCombo.make('rentalStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS', 
    		{ 
	    	    id: "code",              // 콤보박스 value 에 지정할 필드명.
		        name: "codeName",  // 콤보박스 text 에 지정할 필드명.              
		        isShowChoose: false,
		        isCheckAll : false,
		        type : 'M'
		        });
    //Customer Type
    CommonCombo.make("customerType", "/common/selectCodeList.do", {groupCode : '8'}, '964', {isShowChoose: false});
    //Company Type
    CommonCombo.make("companyType", "/common/selectCodeList.do", {groupCode : '95'}, '', {isShowChoose: false , isCheckAll : false, type: "M"});
    //Opening Aging Month
    CommonCombo.make("openMonth", "/common/selectCodeList.do", {groupCode : '330'}, '4|!|5|!|6',  
    		{
                id: "code",
                name:"codeName",
                isShowChoose: false , 
                isCheckAll : false, 
                type: "M"
             });
    //RosCaller
    CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {userId : '${SESSION_INFO.userName}'}, '',  {id:"agentId", name:"agentName", isCheckAll : false, isShowChoose: true });

    CommonCombo.make("rosStatus", "/common/selectCodeList.do", {groupCode : '391'}, '',  {isShowChoose: true});  //Reason Code
    
    //$("#rosCaller").prop("disabled", true);
    //$("#rosCaller").attr("class", "w100p disabled");
    $("#companyType").multipleSelect("disable");
    fn_companyList();
    fn_agentList();
    
    creatGrid();
    creatRosCallGrid();

    $("#rosCallGrid").hide();
    
   /*  $("#customerType").on("change", function () {
    	 var $this = $(this);

         if ($this.val() == 965) {
             $("#companyType").attr("disabled", false);  
             $("#companyType").attr("class" , "");        	 
         }else{
        	 $("#companyType").attr("disabled", true);  
        	 $("#companyType").attr("class" , "disabled");
         }
    }); */
    
    //엑셀 다운
    $('#excelDown').click(function() {        
       GridCommon.exportTo("assignGrid", 'xlsx', "RCMS Assign List");
    });
    
   // fn_selectListAjax();
});


function fn_companyList(){
    
    Common.ajax("GET", "/common/selectCodeList.do", {groupCode : '95'}, function(result) {
    	companyList = result;
        console.log(companyList);
    }, null, {async : false});
}



function fn_agentList(){
    
    Common.ajax("GET", "/sales/rcms/selectRosCaller", '', function(result) {
    	agentList = result;
        console.log(agentList);
    }, null, {async : false});
}



function creatGrid(){

        var assignColLayout = [ 
              {dataField : "salesOrdId", headerText : "", width : 90  , visible:false   },
              {dataField : "custBillId", headerText : "Order No.", width : 80 , visible:false     },
              {dataField : "salesOrdNo", headerText : "Order No.", width : 80 , editable       : false   },
              {dataField : "salesDt", headerText : "Order Date", width : 90 , editable       : false       },
              {dataField : "code", headerText : "App<br/>Type", width : 60 , editable       : false       },
              {dataField : "openRentalStus", headerText : "Rental<br/>Status", width : 80 , editable       : false        },
              {dataField : "stkDesc", headerText : "Product", width : 110, 	  editable       : false },
              {dataField : "name", headerText : "Customer Name", width : 130 , editable       : false        },
              {dataField : "nric", headerText : "NRIC", width : 90, 	  editable       : false },
              {dataField : "colctTrget", headerText : "Open O/S<br/>Target", width : 80  , editable       : false,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "rentAmt", headerText : "Current<br/>O/S", width : 75  , editable       : false ,   dataType : "numeric", formatString : "#,##0.00", },
              {dataField : "openMthAging", headerText : "Open Aging<br/>Month", width : 95  , editable       : false      } ,
              {dataField : "sensitiveFg", headerText : "Sensitive", width : 70   ,editable       : false    }             
              ];
        

        var assignOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             }; 
        
        assignGrid = GridCommon.createAUIGrid("#assignGrid", assignColLayout, "", assignOptions);
        
         // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellDoubleClick", function(event){
                          
              
         });
         
         //셀 클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellClick", function(event){            
              $("#orderNo").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdNo"));              
              $("#salesOrdId").val(AUIGrid.getCellValue(assignGrid , event.rowIndex , "salesOrdId"));       

              fn_selectRosCallListAjax();
         }); 
         
}

function creatRosCallGrid(){

        var rosLayout = [ 
              {dataField : "rosDt", headerText : "ROS Month", width : 250  ,  editable       : false    },
              {dataField : "rosCallerUserId", headerText : "Caller", width : 250 , editable       : false   }
              ];
        

        var rosOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             }; 
        
        rosCallGrid = GridCommon.createAUIGrid("#rosCallGrid", rosLayout, "", rosOptions);
         
}

 //리스트 조회.
function fn_selectListAjax() {  
	 
	 if($("#rentalStatus").val() == ""){
	        Common.alert("Please select a Rental Status.");
	        return ;
	 }
	 
	if($("#customerType").val() == "964"){
          $("#companyType").val("");   
    }
	 
	//$("#rosCaller").prop("disabled", false);
	$("#appType").prop("disabled", false);
		
	
    Common.ajax("GET", "/sales/rcms/selectAssignedList", $("#searchForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(assignGrid, result);
      
      $("#orderNo").val("");              
      $("#salesOrdId").val("");  
      //$("#rosCaller").prop("disabled", true);
      $("#appType").prop("disabled", true);
      $("#rosCallGrid").hide();

  });
}
 //리스트 조회.
function fn_selectRosCallListAjax() {  
		
    Common.ajax("GET", "/sales/rcms/selectRosCallDetailList", {salesOrdId :$("#salesOrdId").val()}, function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(rosCallGrid, result);      
      $("#rosCallGrid").show();
  });
}

function fn_newROSCall(){
    
    //Validation
    var selectedItem = AUIGrid.getSelectedItems(assignGrid);
    if(selectedItem.length <= 0){
        Common.alert(" No result selected. ");
        return;
    }
    //Popup
    Common.popupDiv("/sales/rcms/newRosCallPop.do", {salesOrderId : selectedItem[0].item.salesOrdId , ordNo : selectedItem[0].item.salesOrdNo, custId : selectedItem[0].item.custId, custBillId : selectedItem[0].item.custBillId}, null , true , '_newDiv');
}
 
function fn_customerChng(){
    
    if($("#customerType").val() == "964"){
        $("#companyType").multipleSelect("disable");
    }else{
        $("#companyType").multipleSelect("enable");
    }
    
} 
 
function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_edit(){
	
	if($("#salesOrdId").val() == ""){
		Common.alert("Please select data to edit. ");
		return;
	}
	Common.popupDiv("/sales/rcms/updateRemarkPop.do",null, fn_selectListAjax, true, "updateRemarkPop");
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>RCMS List by Agent</h2>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"  id="btnUpload" onclick="javascript:fn_newROSCall();"></span>Ros Call</a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnSave" onclick="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnClear" onclick="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="editForm" name="editForm" action="#" method="post">
    <input type="hidden" id="orderNo" name="orderNo" />
    <input type="hidden" id="salesOrdId" name="salesOrdId" />
</form>
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">RCMS APP Type<span class="must">*</span></th>
        <td>
        <select id="appType" name="appType" class="w100p disabled" disabled="disabled" >
        </select>
        </td>
        <th scope="row">Order Status<span class="must">*</span></th>
        <td>
          <select  id="orderStatus" name="orderStatus" class="w100p"></select>
        </td>
        <th scope="row">Rental Status<span class="must">*</span></th>
        <td>        
        <select id="rentalStatus" name="rentalStatus" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Customer Type<span class="must">*</span></th>
        <td>
          <select  id="customerType" name="customerType" class="w100p" onchange="javascript:fn_customerChng();"></select>
        </td>
        <th scope="row">Company Type</th>
        <td>
        <select id="companyType" name="companyType" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row">Opening Aging Month</th>
        <td>
        <select id="openMonth" name="openMonth" class="multy_select w100p" multiple="multiple">
        </select>
        <!-- 
        <input type="text" title="DOB" id="_dob" name="dob" placeholder="DD/MM/YYYY" class="j_date" /> -->
        </td>
    </tr>
    <tr>
        <th scope="row">ROS Caller</th>
        <td>          
        <select id="rosCaller" name="rosCaller" class="w100p" >
        </select>
        </td>
        <th scope="row">Order No.</th>
        <td>        
        <input type="text" title="" placeholder="" class="w100p" id="orderNo" name="orderNo"/>
        </td>
        <th scope="row">Customer ID</th>
        <td>
        <input type="text" title="" placeholder="" class="w100p" id="customerId" name="customerId" />
        </td>
    </tr>
    <tr>
        <th scope="row">ROS Status</th>
        <td>
        <select class="w100p" id="rosStatus" name="rosStatus"></select>
        </td>
        <th scope="row">Recall Date</th>
        <td><input type="text"  placeholder="DD/MM/YYYY" class="j_date w100p" id="_reCallYMD" name="reCallDtYmd"/></td>
        <th scope="row">Recall Time</th>
        <td>
        <div class="time_picker" style="width: 43%"><!-- time_picker start -->
        <input type="text" title="" placeholder="" class="time_date w100p"  id="stReCallTime" />
        <ul>
            <li>Time Picker</li>
            <li><a href="#">00:00:00</a></li>
            <li><a href="#">01:00:00</a></li>
            <li><a href="#">02:00:00</a></li>
            <li><a href="#">03:00:00</a></li>
            <li><a href="#">04:00:00</a></li>
            <li><a href="#">05:00:00</a></li>
            <li><a href="#">06:00:00</a></li>
            <li><a href="#">07:00:00</a></li>
            <li><a href="#">08:00:00</a></li>
            <li><a href="#">09:00:00</a></li>
            <li><a href="#">10:00:00</a></li>
            <li><a href="#">11:00:00</a></li>
            <li><a href="#">12:00:00</a></li>
            <li><a href="#">13:00:00</a></li>
            <li><a href="#">14:00:00</a></li>
            <li><a href="#">15:00:00</a></li>
            <li><a href="#">16:00:00</a></li>
            <li><a href="#">17:00:00</a></li>
            <li><a href="#">28:00:00</a></li>
            <li><a href="#">19:00:00</a></li>
            <li><a href="#">20:00:00</a></li>
            <li><a href="#">21:00:00</a></li>
            <li><a href="#">22:00:00</a></li>
            <li><a href="#">24:00:00</a></li>
        </ul>
        </div>
        To
        <div class="time_picker" style="width: 43%"><!-- time_picker start -->
         <input type="text" title="" placeholder="" class="time_date w100p" id="edReCallTime" />
        <ul>
            <li>Time Picker</li>            
            <li><a href="#">00:00:00</a></li>
            <li><a href="#">01:00:00</a></li>
            <li><a href="#">02:00:00</a></li>
            <li><a href="#">03:00:00</a></li>
            <li><a href="#">04:00:00</a></li>
            <li><a href="#">05:00:00</a></li>
            <li><a href="#">06:00:00</a></li>
            <li><a href="#">07:00:00</a></li>
            <li><a href="#">08:00:00</a></li>
            <li><a href="#">09:00:00</a></li>
            <li><a href="#">10:00:00</a></li>
            <li><a href="#">11:00:00</a></li>
            <li><a href="#">12:00:00</a></li>
            <li><a href="#">13:00:00</a></li>
            <li><a href="#">14:00:00</a></li>
            <li><a href="#">15:00:00</a></li>
            <li><a href="#">16:00:00</a></li>
            <li><a href="#">17:00:00</a></li>
            <li><a href="#">28:00:00</a></li>
            <li><a href="#">19:00:00</a></li>
            <li><a href="#">20:00:00</a></li>
            <li><a href="#">21:00:00</a></li>
            <li><a href="#">22:00:00</a></li>
            <li><a href="#">24:00:00</a></li>
        </ul>
        </div><!-- time_picker end -->
        </td>
    </tr>
    <tr>
        <th scope="row">PTP Date</th>
        <td colspan="2">
        <div class="date_set" style="width: 70%"><!-- date_set start -->
        <p><input type="text" placeholder="DD/MM/YYYY" class="j_date"  id="stPtpDate" readonly="readonly" name="stPtpDate"/></p>
        <span>To</span>
        <p><input type="text" placeholder="DD/MM/YYYY" class="j_date"  id="edPtpDate" readonly="readonly" name="edPtpDate"/></p>
        </div>
        </td>
        <td colspan="3">
    </tr>
    </tbody>
    </table><!-- table end -->
    
    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn"><a href="#" id="_custVALetterBtn">Bad Account RAW</a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->
    
    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns mt10">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_edit();">Remark</a></p></li>   
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="assignGrid" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<article class="grid_wrap" ><!-- grid_wrap start -->
    <div id="rosCallGrid" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
