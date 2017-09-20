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
    var myGridID_07T;
    
    $(document).ready(function() {
        createAUIGrid();
        // cellClick event.
        AUIGrid.bind(myGridID_07T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
         
        //Rule Book Item search
        $("#search_07T").click(function(){  
        	/* var ordId = $("#ordId_07T").val();
        	var memberId = $("#memberId_07T").val();
        	var codeId = $("#codeId_07T").val();
        	if(ordId == "" || ordId == null){
        		Common.alert("<spring:message code='sys.msg.necessary' arguments='ORDER ID' htmlEscape='false'/>");
                return false;
        	}else if(memberId == "" || memberId == null){
        		Common.alert("<spring:message code='sys.msg.necessary' arguments='MEMBER ID' htmlEscape='false'/>");
                return false;
            }else if(codeId == "" || codeId == null){
            	Common.alert("<spring:message code='sys.msg.necessary' arguments='ORG Group' htmlEscape='false'/>");
                return false;
            }else{ */
	            Common.ajax("GET", "/commission/calculation/selectDataCMM007T", $("#form_07T").serialize(), function(result) {
	                console.log("성공.");
	                console.log("data : " + result);
	                AUIGrid.setGridData(myGridID_07T, result);
	                AUIGrid.addCheckedRowsByValue(myGridID_07T, "isexclude", "1");
	            });
        	//}
        });
        
        $("#save_07T").click(function(){  
        	/* var ordId = $("#ordId_07T").val();
            var memberId = $("#memberId_07T").val();
            var codeId = $("#codeId_07T").val();
            if(ordId == "" || ordId == null){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='ORDER ID' htmlEscape='false'/>");
                return false;
            }else if(memberId == "" || memberId == null){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='MEMBER ID' htmlEscape='false'/>");
                return false;
            }else if(codeId == "" || codeId == null){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='ORG Group' htmlEscape='false'/>");
                return false;
            }else{ */
            	Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExculde);
	        	
            //}
        });
        
    });
    function fn_saveExculde(){
    	var checkdata = AUIGrid.getCheckedRowItemsAll(myGridID_07T);
        var check     = AUIGrid.getCheckedRowItems(myGridID_07T);
        var formList = $("#form_07T").serializeJSON();       //폼 데이터
        
        //param data array
        var data = {};
        
        data.check   = check;
        data.checked = check;
        data.form = formList;
        
        Common.ajax("POST", "/commission/calculation/updatePrdData_07T.do", data , function(result) {
            // 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            $("#search_07T").trigger("click");
        });
    }
    
   function createAUIGrid() {
    var columnLayout3 = [ {
        dataField : "ordId",
        headerText : "ORD ID",
        style : "my-column",
        editable : false
    },{
        dataField : "memId",
        headerText : " MEM ID",
        style : "my-column",
        editable : false
    },{
        dataField : "code",
        headerText : " CODE",
        style : "my-column",
        editable : false
    },{
        dataField : "ordTypeId",
        headerText : "ORD TYPE ID",
        style : "my-column",
        editable : false
    },{
        dataField : "productId",
        headerText : "PRODUCT ID",
        style : "my-column",
        editable : false
    },{
        dataField : "unitValu",
        headerText : "UNIT VALU",
        style : "my-column",
        editable : false
    },{
        dataField : "prc",
        headerText : "PRC",
        style : "my-column",
        editable : false
    },{
        dataField : "pvValu",
        headerText : "PV VALU",
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
        dataField : "isexclude",
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
    myGridID_07T = AUIGrid.create("#grid_wrap_07T", columnLayout3,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0007T", $("#form_07T").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
			   /* var ordId = $("#ordId_07T").val();
		       var memberId = $("#memberId_07T").val();
		       var codeId = $("#codeId_07T").val();
		       if(ordId == "" || ordId == null){
		           Common.alert("<spring:message code='sys.msg.necessary' arguments='ORDER ID' htmlEscape='false'/>");
		           return false;
		       }else if(memberId == "" || memberId == null){
		           Common.alert("<spring:message code='sys.msg.necessary' arguments='MEMBER ID' htmlEscape='false'/>");
		           return false;
		       }else if(codeId == "" || codeId == null){
		           Common.alert("<spring:message code='sys.msg.necessary' arguments='ORG Group' htmlEscape='false'/>");
		           return false;
		       }else{ */
			       //excel down load name 형식 어떻게 할지?
			       var fileName = $("#fileName").val();
			       var searchDt = $("#CMM0007T_Dt").val();
			       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
			       var month = searchDt.substr(0,searchDt.indexOf("/"));
			       var code = $("#code_07T").val();
			       var codeId = $("#codeId_07T").val();
			       var memberId = $("#memberId_07T").val();
			       var ordId = $("#ordId_07T").val();
			       var useYnCombo = $("#useYnCombo_07T").val();
			       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
			       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
			       window.open("<c:url value='/commission/down/excel-xlsx-streaming.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&codeId="+codeId+"&memberId="+memberId+"&ordId="+ordId+"&useYnCombo="+useYnCombo+"'/>");
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
        <form id="form_07T">
           <input type="hidden" name="code" id="code_07T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="excelDownName"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_07T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
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
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0007T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">ORG Group<span class="must">*</span></th>
                        <td><select id="codeId_07T" name="codeId" style="width: 100px;">
                                <option value=""></option>
                                <c:forEach var="list" items="${orgGrList }">
                                    <option value="${list.cdid}">${list.cd}</option>
                                </c:forEach>
                        </select></td>
                        <th scope="row">MEMBER ID<span class="must">*</span></th>
                        <td>
                              <input type="text" id="memberId_07T" name="memberId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                        </td>
                        </tr>
                        <tr>
                        <th scope="row">ORD ID<span class="must">*</span></th>
                        <td>
                              <input type="text" id="ordId_07T" name="ordId" style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
                        </td>
                        <th scope="row">isEx</th>
                        <td colspan="3">
                          <select id="useYnCombo_07T" name="useYnCombo" style="width:100px;">
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
                    <a href="#" id="save_07T"><spring:message code='sys.btn.save'/></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_07T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
