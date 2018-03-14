
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var   logGrid;


$(document).ready(function() {
    createAUIGrid() ;
    
});



function createAUIGrid() {
	  //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "appType",
        headerText : "appType",
        editable : false,
        width : 100
    }, {
        dataField : "salesOrdId",
        headerText : "salesOrdNo",
        editable : false,
        width : 100
    }, {
        dataField : "svcNo",
        headerText : "svcNo",
        editable : false,
        width : 100
    } , {
        dataField : "crtDt",
        headerText : "Reques Date",
        editable : false,
        width : 110 , dataType : "date", formatString : "dd/mm/yyyy"
    }, {
        dataField : "errMsg",
        headerText : "errMsg",
        editable : false,
        width : 300
    }, {
        dataField : "trnscId",
        headerText : "trnscId",
        editable : false,
        width : 100
    }
 ];
	  
     // 그리드 속성 설정
    var gridPros = {
	    	     usePaging              : true,         //페이징 사용
	             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	             showStateColumn     : false,             
	             displayTreeOpen     : false,            
	             selectionMode       : "singleRow",  //"multipleCells",            
	             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
	             editable :false 
    };
    
    logGrid = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
	
}



function fn_search(){
	
	if($('#LOGTYPE').val() == ""){
	     Common.alert("<b> No LOGTYPE selected.</b>");
		return ;
	}
	
	
	   
    if($('#TRAN_STUS_CD').val() == ""){
         Common.alert("<b> No TRAN_STUS_CD selected.</b>");
        return ;
    }
    
	
    var startDate = $('#S_DATE').val();
    var endDate = $('#E_DATE').val();
    
	    
	 if(startDate == "" || endDate =="" ){
	      Common.alert("<b> NO  Request Date  selected </b>");
	     return ;
	 }
    
    
    if( fn_getDateGap(startDate , endDate) > 30){
        Common.alert('Start date can not be more than 30 days before the end date.');
        return;
    }


     Common.ajax("GET", "/services/as/getAPILogList.do", $("#apiForm").serialize(), function(result) {
         console.log("성공.");
         console.log( result);
         AUIGrid.setGridData(logGrid, result);
     });
}


function fn_getDateGap(sdate, edate){
    
    var startArr, endArr;
    
    startArr = sdate.split('/');
    endArr = edate.split('/');
    
    var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
    var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);
    
    var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;
    
    
    return gap;
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>API LOG List</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="javascript:fn_search()"> <span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post"  id='apiForm' name='apiForm'>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:100px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:80px" />
	<col style="width:*" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">APP Type</th>
	<td>
	<select class="w100p" id="LOGTYPE" name="LOGTYPE" >
		<option value="HS">HS</option>
		<option value="AS">AS</option>
		<option value="INS">INS</option>
		<option value="PR">PR</option>
	</select>
	
	
	</td>
	<th scope="row">LOG Status</th>
	<td>
	<select  class="w100p" id="TRAN_STUS_CD" name="TRAN_STUS_CD"  >
		<option value="Y">Y</option>
		<option value="N">N</option>
		<option value="E">E</option>
	</select>
	</td>
	<th scope="row">Request Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id='S_DATE' name='S_DATE' /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id='E_DATE' name='E_DATE'  /></p>
	</div><!-- date_set end -->
	</td>
</tr>

</tbody>
</table><!-- table end -->




<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_asList" style="width: 100%; height: 400px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
