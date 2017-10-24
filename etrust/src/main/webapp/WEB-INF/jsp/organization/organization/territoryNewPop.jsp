
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>



<script type="text/javaScript" language="javascript">



function fn_uploadFile() {

    var formData = new FormData();
    formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("comBranchTypep", $("#comBranchTypep").val());

    Common.ajaxFile("/organization/territory/excelUpload", formData, function (result) {
      
    	console.log(result);
    	
    	if(result.code == "99"){
            Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
	}
    });
}



// 파일 다운로드는 db 설계에 따른 재 구현이 필요함.  현재는 단순 테스트용입니다.
function fn_downFile() {

    var fileName = $("#fileName").val();

    //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
    //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
    window.open("<c:url value='/sample/down/excel-xlsx-streaming.do?fileName=" + fileName + "'/>");
}



$(document).ready(function(){
	
});





</script>



<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Upload Assign Change Request (Excel Update) </h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Template</a></p></li>
</ul>


<aside class="title_line"><!-- title_line start -->
<h2>Upload Assign Change Request</h2>
</aside><!-- title_line end -->



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>

        
    <th scope="row">Branch Type</th>
    <td>
            <select class="multy_select w100p"  id="comBranchTypep" name="comBranchTypep">
               <option value="42">Cody Branch</option>
               <option value="43">Dream Service Center</option>
            </select>
            
    </td>
</tr>
<tr>
                <th scope="row">File</th>
                    <td>
					    <div class="auto_file"><!-- auto_file start -->
					       <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
					    
							    <input title="file add" type="file">
							    <label><span class="label_text"><a href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
						   </form>
						</div><!-- auto_file end -->
						    
						    <p class="btn_sky"><a href="javascript:fn_uploadFile()" >ExcelUpLoad</a></p> 
						    
						    
				    </td>
	        </tr>
</tbody>
</table><!-- table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->