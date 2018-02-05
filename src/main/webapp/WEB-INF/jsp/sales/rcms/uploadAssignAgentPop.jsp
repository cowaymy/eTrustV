<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script  type="text/javascript">
var uploadGrid;
var agentGrid;

$(document).ready(function(){

	setInputFile();
	creatGrid();
	
	$("#uploadGrid").hide();
    $("#btnPopSave").hide();
	
	//**************************************************
	//** 업로드 파일 내용을 Grid에 적용하기
	//**************************************************
	// 파일 선택하기
	$('#fileSelector').on('change', function(evt) {

	        var data = null;
	        var file = evt.target.files[0];
	        if (typeof file == "undefined") {
	            return;
	        }
	        
	        var reader = new FileReader();
	        //reader.readAsText(file); // 파일 내용 읽기
	        reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
	        reader.onload = function(event) {
	            if (typeof event.target.result != "undefined") {
	            		            	
	                // 그리드 CSV 데이터 적용시킴
	                AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);
	                
	                //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
	                AUIGrid.removeRow(uploadGrid,0);
	                
	                fn_checkAgentList();
                    
	            } else {
	                Common.alert('<spring:message code="sal.alert.msg.noDataToImport" />');
	            }
	        };

	        reader.onerror = function() {
	        	Common.alert('<spring:message code="sal.alert.msg.unableToRead" />' + file.fileName);
	        };

	});  
	
});

function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

function creatGrid(){

    var upColLayout = [ {
        dataField : "0",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 100
    },{
        dataField : "1",
        headerText : '<spring:message code="sal.title.agentId" />',
        width : 150
    }];
    
    var agentLayout = [ {
        dataField : "orderNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 100
    },{
        dataField : "agentId",
        headerText : '<spring:message code="sal.title.agentId" />',
        width : 150
    },{
        dataField : "msg",
        headerText : '<spring:message code="sales.ErrorMessage" />'
    }];
    

    var upOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : false,
               editable : false,
               headerHeight : 30,
               softRemoveRowMode:false
         }; 
    
    uploadGrid = GridCommon.createAUIGrid("#uploadGrid", upColLayout, "", upOptions); 
    agentGrid = GridCommon.createAUIGrid("#agentGrid", agentLayout, "", upOptions); 
}


function fn_checkAgentList(){
    var data = GridCommon.getGridData(uploadGrid);
    Common.ajax("POST", "/sales/rcms/checkAgentList", data, function(result)    {

        AUIGrid.clearGridData(agentGrid);

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);              
                                
        if(result.data.length > 0){
            AUIGrid.setGridData(agentGrid, result.data);
            $("#btnPopSave").hide();
        }else{
            $("#btnPopSave").show();
        }
               
                
    }
    , function(jqXHR, textStatus, errorThrown){
         try {
        	    console.log("Fail Status : " + jqXHR.status);
        	    console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
        	  console.log(e);
          }
     });

}

function fn_save(){
    var data = GridCommon.getGridData(uploadGrid);

    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){        	
        	
        Common.ajax("POST", "/sales/rcms/saveAgentList", data, function(result){

            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);

            Common.alert("Success To Save" + DEFAULT_DELIMITER + "Agent list successfully saved.");
        }
        , function(jqXHR, textStatus, errorThrown){
            try {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                }
            catch (e)
            {
              console.log(e);
            }
            Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.failToUpdateAgentList" />');
        });

    }));
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.uploadAssignToAssign" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.SelectCSVFile" /><span class="must">*</span></th>
	<td colspan="3">
	<div class="auto_file"><!-- auto_file start -->
	<input type="file" id="fileSelector" title="file add" /> 
	</div><!-- auto_file end -->
	<p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/AssignToAgent_Format.csv"><spring:message code="sales.DownloadCSVFormat" /></a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:350px; margin:0 auto;"></div>
    <div id="agentGrid" style="width:100%; height:310px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" id="btnPopSave" onclick="javascript:fn_save();"><spring:message code="sales.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->