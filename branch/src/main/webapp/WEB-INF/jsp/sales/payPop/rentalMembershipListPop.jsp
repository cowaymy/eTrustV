<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


var  gridID;
var  rentalList;

$(document).ready(function(){
	
	  
    if('${rentalList}'=='' || '${rentalList}' == null){
    }else{
    	rentalList = JSON.parse('${rentalList}');      
        console.log(rentalList);
    }   
    
	
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

});


function createAUIGrid() {
        
        var columnLayout = [
                            { dataField : "srvCntrctRefNo", headerText  : "Membership<br/>No.",    width : 100,  editable : false},
                            { dataField : "salesOrdNo", headerText  : "Order No.",width : 80,  editable: false },
                            { dataField : "code",   headerText  : "Status",  width          : 60,   editable       : false},
                            { dataField : "cntrctRentalStus", headerText  : "Rent<br/>Status",  width          : 60, editable       : false },
                            { dataField : "srvCntrctNetMonth",headerText  : "Net Mth",  width          : 65,   editable       : false},
                            { dataField : "srvCntrctNetYear",         headerText  : "Net Year",   width          : 70,     editable       : false },
                            { dataField : "srvPrdStartDt",       headerText  : "Start Date",  width          : 90, editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "srvPrdExprDt",       headerText  : "Expire Date",  width          : 90, editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "srvCntrctPacDesc",     headerText  : "Package",  width          : 130,    editable       : false },
                            { dataField : "name",      headerText  : "Customer Name",   width          : 150,    editable       : false },
                            { dataField : "srvCntrctCrtDt",     headerText  : "Created",    width          : 90,        editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "userName",     headerText  : "Creator",    width : 100,       editable  : false}
                               
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,  headerHeight        : 30, showRowNumColumn : true};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
        
        if(rentalList != '' ){
            AUIGrid.setGridData(gridID, rentalList);
        } 
    }

</script>
 
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Rental Membership</h1>
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

