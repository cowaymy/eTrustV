<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">
var uploadGrid;
var cnvrListGrid;

$(document).ready(function(){
	setInputFile();
	creatGrid();
	
	$("#uploadGrid").hide();
	fn_changeCombo("REG");
	
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
	                
	                fn_checkNewCnvr();
                    
	            } else {
	                Common.alert('No data to import!');
	            }
	        };

	        reader.onerror = function() {
	        	Common.alert('Unable to read ' + file.fileName);
	        };

	});  
	
});

function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

function fn_changeCombo(value){
	
	var targetObj = document.getElementById("pRsCnvrStusTo");
	
	for (var i = targetObj.length - 1; i >= 0; i--) {
        targetObj.remove(i);
    }
	
	if(value=="REG"){
		$('<option />', { value: "INV", text: "<spring:message code="sales.Investigate" />"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
	}else if(value=="INV"){
		$('<option />', { value: "REG", text: "<spring:message code="sales.Regular" />" }).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
		$('<option />', {value: "SUS", text: "<spring:message code="sales.Suspend" />" }).appendTo($("#pRsCnvrStusTo"));
	}else if(value=="SUS"){
        $('<option />', { value: "INV", text: "<spring:message code="sales.Investigate" />"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
		$('<option />', { value: "RET", text: "<spring:message code="sales.Return" />"}).appendTo($("#pRsCnvrStusTo"));
	}else if(value=="RET"){
        $('<option />', { value: "SUS", text: "<spring:message code="sales.Suspend" />"}).appendTo($("#pRsCnvrStusTo")).attr("selected", "true");
        $('<option />', { value: "TER", text: "<spring:message code="sales.Terminate" />"}).appendTo($("#pRsCnvrStusTo"));
    }
}


function creatGrid(){

    var upColLayout = [ {
        dataField : "1",
        headerText : '<spring:message code="sales.MembershipNo" />',
        width : 150
    },{
        dataField : "0",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 100
    }];
    
    var cnvrColLayout = [ {
        dataField : "membershipNo",
        headerText : '<spring:message code="sales.MembershipNo" />',
        width : 150
    },{
        dataField : "orderNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 100
    },{
        dataField : "stusFrom",
        headerText : '<spring:message code="sales.StatusFrom" />',
        width : 150
    },{
        dataField : "stusTo",
        headerText : '<spring:message code="sales.StatusTo" />',
        width : 100
    }, {
        dataField : "msg",
        headerText : '<spring:message code="sales.ErrorMessage" />'
    }, {
        dataField : "chkYn",
        headerText : '',
        visible : false
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
    cnvrListGrid = GridCommon.createAUIGrid("#cnvrListGrid", cnvrColLayout, "", upOptions); 
}


function fn_checkNewCnvr(){
    var data = GridCommon.getGridData(uploadGrid);
    data.form = $("#newCnvrForm").serializeJSON();

    Common.ajax("POST", "/sales/membership/checkNewCnvrList", data, function(result)    {


        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);              
                                
        AUIGrid.setGridData(cnvrListGrid, result.data);
                
        AUIGrid.setProp(cnvrListGrid, "rowStyleFunction", function(rowIndex, item) {
            if(item.chkYn == "N") {
                return "my-row-style";
            }
            return "";

        }); 

        // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
        AUIGrid.update(cnvrListGrid);
                
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
                  alert("Fail : " + jqXHR.responseJSON.message);
     });

}

function fn_saveNewCnvr(){
    var data = GridCommon.getGridData(cnvrListGrid);
    data.form = $("#newCnvrForm").serializeJSON();

    var idx = AUIGrid.getRowCount(cnvrListGrid);
    
    for(var i=0; i < idx; i++){    	
    	if(AUIGrid.getCellValue(cnvrListGrid, i, "chkYn") == "N"){
    		Common.alert("<spring:message code="sales.msg.error" />");
    		return;
    	}    		
    }
    
    if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){        	
        	
        Common.ajax("POST", "/sales/membership/saveNewCnvrList", data, function(result){

            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
                      
            for(var i = 0; i < result.data.length; i++){
                if(result.data[i].chkYn == "Y"){
                    var msg1 = result.data[i].convertNo;
                    var msg2 = result.data[i].stusFrom;
                    var msg3 = result.data[i].stusTo;

                    Common.alert("<spring:message code="sales.title.successfully" />" + DEFAULT_DELIMITER + "<spring:message code='sales.msg.successfully' arguments='"+msg1+" ; "+msg2+" ; " +msg3+" ' htmlEscape='false' argumentSeparator=';' />");
                }
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
            alert("Fail : " + jqXHR.responseJSON.message);
        });

    }));
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sales.newTitle" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
<form action="#" method="post" id="newCnvrForm" name="newCnvrForm">

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
	<th scope="row"><spring:message code="sales.StatusConversion" /><span class="must">*</span></th>
	<td>
    <select class="w100p" id="pRsCnvrStusFrom" name ="pRsCnvrStusFrom" onchange="javascript:fn_changeCombo(this.value);">
        <option value="REG"><spring:message code="sales.Regular" /></option>
        <option value="INV"><spring:message code="sales.Investigate" /></option>
        <option value="SUS"><spring:message code="sales.Suspend" /></option>
        <option value="RET"><spring:message code="sales.Return" /></option>
    </select>
	</td>
	<th scope="row"><spring:message code="sales.To" /></th>
	<td>
	<select class="w100p"  id="pRsCnvrStusTo" name="pRsCnvrStusTo">
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.Remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" id="pRsCnvrRem" name="pRsCnvrRem"></textarea></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.SelectCSVFile" /><span class="must">*</span></th>
	<td colspan="3">
	<div class="auto_file"><!-- auto_file start -->
	<input type="file" id="fileSelector" title="file add" /> 
	</div><!-- auto_file end -->
	<p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/sales/ConversionRequest_Format.csv"><spring:message code="sales.DownloadCSVFormat" /></a></p>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:350px; margin:0 auto;"></div>
    <div id="cnvrListGrid" style="width:100%; height:310px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_saveNewCnvr();"></span><spring:message code="sales.SAVE" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->