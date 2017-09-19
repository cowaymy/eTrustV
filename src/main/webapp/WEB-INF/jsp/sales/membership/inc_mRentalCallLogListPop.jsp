<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>


<script type="text/javascript">

var mRCallLogGrid; // membershipQuotInfoFilterGridID list


$(document).ready(function(){  
	
	createMRCallLogGrid();  
	AUIGrid.resize(mRCallLogGrid, 940,300)
   
});


function createMRCallLogGrid(){
    
    var cLayout = [
         {dataField : "code",headerText : "Status", width : 100 ,editable : false},
         {dataField : "cnfmLogMsg", headerText : "Call Message", width : 300 ,editable : false},
         {dataField : "cnfmLogSmsMsg", headerText : "SMS Message", width :300 ,editable : false},
         {dataField : "userName", headerText : "Key By", width :100 ,editable : false},
         {dataField : "cnfmLogCrtDt", headerText : "Key At", width :120 ,dataType : "date", formatString : "dd-mm-yyyy" ,editable : false}
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1,selectionMode : "singleRow",  showRowNumColumn : true};  
    mRCallLogGrid = GridCommon.createAUIGrid("#call_grid_wrap", cLayout,'' ,gridPros); 
}



function fn_getmRCallLogGridAjax (o){
      Common.ajax("GET", "/sales/membershipRental/callLogList",{CNFM_CNTRCT_ID:o.SRV_CNTRCT_ID }, function(result) {
         console.log(result);
         AUIGrid.setGridData(mRCallLogGrid, result);
      });
}




</script>



<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="call_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
    </article><!-- grid_wrap end -->
</article><!-- tap_area end -->