<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align: left;
    margin-top: -20px;
}
</style>

<script type="text/javaScript">
    $(function() {
        //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
        //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
        //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
        // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
        // doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
    });
    
    
    var myGridID_24T;
    $(document).ready(function() {
        createAUIGrid();
        // cellClick event.
        AUIGrid.bind(myGridID_24T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
         
        //Rule Book Item search
        $("#search_24T").click(function(){ 
            Common.ajax("GET", "/commission/calculation/selectDataCMM024T", $("#form_24").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID_24T, result);
                AUIGrid.addCheckedRowsByValue(myGridID_24T, "isExclude", "1");
            });
        });
        
    });
    
   function createAUIGrid() {
	    var columnLayout3 = [ {
	        dataField : "emplyId",
	        headerText : "EMPLY ID",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "emplyCode",
	        headerText : "EMPLY_CODE",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "prfomPrcnt",
	        headerText : "PRFOM_PRCNT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "prfomncRank",
	        headerText : "PRFOMNC_RANK",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "totEmply",
	        headerText : "TOT_EMPLY",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "cumltDstrib",
	        headerText : "CUMLT_DSTRIB",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "payoutPrcnt",
	        headerText : "PAYOUT_PRCNT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "payoutAmt",
	        headerText : "PAYOUT_AMT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "taskId",
	        headerText : "TASK ID",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "isExclude",
	        headerText : "IS EXCLUDE",
	        style : "my-column",
	        visible : false,
	        editable : false
	    }];
	    // 그리드 속성 설정
	    var gridPros = {
	        
	        // 페이징 사용       
	        usePaging : true,
	        
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 20,
	        
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true,
	        
	    };
	    myGridID_24T = AUIGrid.create("#grid_wrap_24T", columnLayout3,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0024T", $("#form_24").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
		       //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#CMM0024T_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code_24T").val();
		       var ordId = $("#ordId_24T").val();
		       var emplyId = $("#emplyId_24T").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       window.open("<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&ordId="+ordId+"&emplyId="+emplyId+"'/>");
	       }else{
	           Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
	       }
	   });
   }
   
   function onlyNumber(obj) {
       $(obj).keyup(function(){
            $(this).val($(this).val().replace(/[^0-9]/g,""));
       }); 
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Basic Data</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    
    <section class="pop_body"><!-- pop_body start -->
       <aside class="title_line"><!-- title_line start -->
          <h2>Commission calculation Data Collection</h2>
        </aside><!-- title_line end -->
        <form id="form_24">
           <input type="text" name="code" id="code_24T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_24T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </ul>
    
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:200px" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Month/Year<span class="must">*</span></th>
                        <td>
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0024T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">EMPLY ID</th>
                        <td>
                              <input type="text" id="emplyId_24T" name="emplyId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    
        <article class="grid_wrap3"><!-- grid_wrap start -->
            <!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid">
                    <a href="javascript:fn_downFile()" id="addRow"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_24T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
