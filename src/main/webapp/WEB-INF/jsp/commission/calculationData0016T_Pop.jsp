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
    
    
    var myGridID_16T;
    $(document).ready(function() {
        createAUIGrid();
        // cellClick event.
        AUIGrid.bind(myGridID_16T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
         
        //Rule Book Item search
        $("#search_16T").click(function(){  
            Common.ajax("GET", "/commission/calculation/selectDataCMM016T", $("#form_16T").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID_16T, result);
                AUIGrid.addCheckedRowsByValue(myGridID_16T, "isExclude", "1");
            });
        });
        
    });
    
   function createAUIGrid() {
    var columnLayout3 = [ {
        dataField : "cmmsDt",
        headerText : "CMMS_DT",
        style : "my-column",
        editable : false
    },{
        dataField : "cMemId",
        headerText : "C_MEM_ID",
        style : "my-column",
        editable : false
    },{
        dataField : "cMemLev",
        headerText : "C_MEM_LEV",
        style : "my-column",
        editable : false
    },{
        dataField : "pMemId",
        headerText : "P_MEM_ID",
        style : "my-column",
        editable : false
    },{
        dataField : "pMemLev",
        headerText : "P_MEM_LEV",
        style : "my-column",
        editable : false
    },{
        dataField : "tbbLev",
        headerText : "TBB_LEV",
        style : "my-column",
        editable : false
    },{
        dataField : "cnsUnit",
        headerText : "CNS_UNIT",
        style : "my-column",
        editable : false
    },{
        dataField : "cnspvTot",
        headerText : "CNSPV_TOT",
        style : "my-column",
        editable : false
    },{
        dataField : "pnsUnit",
        headerText : "PNS_UNIT",
        style : "my-column",
        editable : false
    },{
        dataField : "tbbTot",
        headerText : "TBB_TOT",
        style : "my-column",
        editable : false
    },{
        dataField : "runId",
        headerText : "RUN_ID",
        style : "my-column",
        visible : false,
        editable : false
    },{
        dataField : "taskId",
        headerText : "TASK ID",
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
        
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        
        showRowAllCheckBox : true

    };
    myGridID_16T = AUIGrid.create("#grid_wrap_16T", columnLayout3,gridPros);
   }
   
   function fn_downFile_16T() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0016T", $("#form_16T").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
		       //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#CMM0016T_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code_16T").val();
		       var payId = $("#payId_16T").val();
		       var ordId = $("#ordId_16T").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       window.open("<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&payId="+payId+"&ordId="+ordId+"'/>");
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
          <h2>Commission Basic Data Collection</h2>
        </aside><!-- title_line end -->
        <form id="form_16T">
           <input type="hidden" name="code" id="code_16T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_16T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </ul>
    
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:100px" />
                    <col style="width:100px" />
                    <col style="width:100px" />
                    <col style="width:100px" />
                    <col style="width:100px" />
                    <col style="width:100px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Month/Year<span class="must">*</span></th>
                        <td>
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0016T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">C_MEM_ID</th>
                        <td>
                              <input type="text" id="cMemId_16T" name="cMemId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                        </td>
                        <th scope="row">P_MEM_ID</th>
                        <td>
                              <input type="text" id="pMemId_16T" name="pMemId" style="width: 100px;" onkeydown="onlyNumber(this)">
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    
        <article class="grid_wrap3"><!-- grid_wrap start -->
            <!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid">
                    <a href="javascript:fn_downFile_16T()" id="addRow"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_16T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
