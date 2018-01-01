<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


var  gridID;
var  transferList;

$(document).ready(function(){
	
	  
    if('${transferList}'=='' || '${transferList}' == null){
    }else{
    	transferList = JSON.parse('${transferList}');      
        console.log(transferList);
    }   
    
	
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

});


function createAUIGrid() {
        
        var columnLayout = [
                            { dataField : "codeName", headerText  : "Membership<br/>No.",    width : 100,  editable : false},
                            { dataField : "code", headerText  : "Order No.",width : 80,  editable: false },
                            { dataField : "salesOrdNo",   headerText  : "Status",  width          : 60,   editable       : false},
                            { dataField : "crtDt",       headerText  : "Start Date",  width          : 90, editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "oldCust",     headerText  : "Package",  width          : 130,    editable       : false },
                            { dataField : "newCust",     headerText  : "Package",  width          : 130,    editable       : false },
                            { dataField : "nric",      headerText  : "Customer Name",   width          : 150,    editable       : false },
                            { dataField : "soExchgCrtDt",     headerText  : "Created",    width          : 90,        editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "userName",     headerText  : "Creator",    width : 100,       editable  : false}
                               
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,  headerHeight        : 30, showRowNumColumn : true};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
        
        if(transferList != '' ){
            AUIGrid.setGridData(gridID, transferList);
        } 
    }

</script>
 
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Order Transfer History</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

