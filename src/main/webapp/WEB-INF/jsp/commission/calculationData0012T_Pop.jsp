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
    
    
    var myGridID_12T;
    $(document).ready(function() {
        createAUIGrid();
        // cellClick event.
        AUIGrid.bind(myGridID_12T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
         
        //Rule Book Item search
        $("#search_12T").click(function(){ 
           /*  var ordId = $("#ordId_12T").val();
            
            if(ordId == "" || ordId == null){
            	Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
                return false;
            }else{ */
	            Common.ajax("GET", "/commission/calculation/selectDataCMM012T", $("#form_12T").serialize(), function(result) {
	                console.log("성공.");
	                console.log("data : " + result);
	                AUIGrid.setGridData(myGridID_12T, result);
	                AUIGrid.addCheckedRowsByValue(myGridID_12T, "isExclude", "1");
	            });
            //}
        });
        
        $("#save_12T").click(function(){  
        	 /* var ordId = $("#ordId_12T").val();
             
             if(ordId == "" || ordId == null){
            	 Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
                 return false;
             }else{ */
            	 Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExculde);
	        	
             //}
        });
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form_12T").serializeJSON(), null, true);
        });
        
    });
    
    function fn_loadOrderSalesman(memId, memCode) {
        $("#salesPersonId_11T").val(memId);
        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);
    }
    
    function fn_saveExculde(){
    	var checkdata = AUIGrid.getCheckedRowItemsAll(myGridID_12T);
        var check     = AUIGrid.getCheckedRowItems(myGridID_12T);
        var formList = $("#form_12T").serializeJSON();       //폼 데이터
        
        //param data array
        var data = {};
        
        data.check   = check;
        data.checked = check;
        data.form = formList;
        
        Common.ajax("POST", "/commission/calculation/updatePrdData_12T.do", data , function(result) {
            // 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            $("#search_12T").trigger("click");
        });
    }
   function createAUIGrid() {
    var columnLayout3 = [ {
        dataField : "clctrId",
        headerText : "CLCTR ID",
        style : "my-column",
        editable : false
    },{
        dataField : "ordId",
        headerText : "ORD ID",
        style : "my-column",
        editable : false
    },{
        dataField : "trgetAmt",
        headerText : "TRGET AMT",
        style : "my-column",
        editable : false
    },{
        dataField : "colctAmt",
        headerText : "COLCT AMT",
        style : "my-column",
        editable : false
    },{
        dataField : "custRaceId",
        headerText : "CUST RACE ID",
        style : "my-column",
        editable : false
    },{
        dataField : "rentPayModeId",
        headerText : "RENT PAY MODE ID",
        style : "my-column",
        editable : false
    },{
        dataField : "custId",
        headerText : "CUST ID",
        style : "my-column",
        editable : false
    },{
        dataField : "runId",
        headerText : "RUN ID",
        style : "my-column",
        visible : false,
        editable : false
    },{
        dataField : "taskId",
        headerText : "TASK ID",
        style : "my-column",
        visible : false,
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
        
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        
        showRowAllCheckBox : true

    };
    myGridID_12T = AUIGrid.create("#grid_wrap_12T", columnLayout3,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0012T", $("#form_12T").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   /* var ordId = $("#ordId_12T").val();
		       
		       if(ordId == "" || ordId == null){
		    	   Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
		           return false;
		       }else{ */
			       //excel down load name 형식 어떻게 할지?
			       var fileName = $("#fileName").val();
			       var searchDt = $("#CMM0012T_Dt").val();
			       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
			       var month = searchDt.substr(0,searchDt.indexOf("/"));
			       var code = $("#code_12T").val();
			       var clctrId = $("#clctrId_12T").val();
			       var ordId = $("#ordId_12T").val();
			       var useYnCombo = $("#useYnCombo_12T").val();
			       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
			       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
			       window.open("<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&clctrId="+clctrId+"&ordId="+ordId+"&useYnCombo="+useYnCombo+"'/>");
		       //}
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
          <h2>Commission Basic Data Collection
          <br>
          ${prdNm } - ${prdDec }</h2>
        </aside><!-- title_line end -->
        <form id="form_12T">
           <input type="hidden" name="code" id="code_12T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_12T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0012T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">Collector ID</th>
                        <td>
                              <input type="text" id="clctrId_12T" name="clctrId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                              <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">ORD ID<span class="must">*</span></th>
                        <td>
                              <input type="text" id="ordId_12T" name="ordId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                        </td>
                        <th scope="row">isEx</th>
                        <td colspan="3">
                          <select id="useYnCombo_12T" name="useYnCombo" style="width:100px;" maxlength="10">
                            <option value="" selected></option>
                            <option value="1">Y</option>
                            <option value="0">N</option>
                        </select>
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
                <li><p class="btn_grid">
                    <a href="#" id="save_12T"><spring:message code='sys.btn.save'/></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_12T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
