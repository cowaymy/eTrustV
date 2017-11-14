<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script>

	//save
	function fn_saveNewNotice(){
		var formData = Common.getFormData("insertNoticeForm");
   //Validation Check
        if($("#ntceSubject").val() == ''){
            Common.alert("Please key in Subject");
            return false;
        }
        if($("#ntceCntnt").val() == ''){
            Common.alert("Please key in Content");
            return false;
        }
            
	Common.ajax("POST", "/notice/insertNotice.do", $("#insertNoticeForm").serializeJSON(), function(result) {
		var gridData = result;
			
          Common.alert(result.message);
           $("#popClose").click();
           fn_selectNoticeListAjax(); 
              
	// 공통 메세지 영역에 메세지 표시.
	Common.setMsg("<spring:message code='sys.msg.success'/>");	
       }, function(jqXHR, textStatus, errorThrown) {
           //Common.alert("실패하였습니다.");
    	   //Common.setMsg("<spring:message code='sys.msg.fail'/>");
       });
		
	}
		
		
		
// 	   $(function(){
// 		  $("#cancle").click(function () {
// 			  $("#close").remove();
// 		   })   
// 	   })
	   
// 	    function fn_reloadPage() {
// 	        fn_selectNoticeListAjax(); //parent Method (Reload)
// 	        $("#popup_wrap").hide();
// 	    }
		
    function onlyNumber(obj) {
        $(obj).keyup(function(){
             $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    }

    function fn_checkbox() {
		if($("#_emgncyFlagCheck").is(":checked") == true){
			$("#_emgncyFlag").val("Y");
		}else{
			$("#_emgncyFlag").val("N");
		}
	}
    
    function fn_close() {
        $("#popClose").click();
    }
    
    function setInputFile2(){//인풋파일 세팅하기
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
    }
    setInputFile2();
    
    $(document).on(//인풋파일 삭제
   	    "click", ".auto_file2 a:contains('Delete')", function(){
   	    var fileNum=$(".auto_file2").length;

   	    if(fileNum <= 1){

   	    }else{
   	        $(this).parents(".auto_file2").remove();
   	    }
   	    
   	    return false;
    });
		   
</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Notice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="insertNoticeForm" name="insertNoticeForm" method="POSt" ><!-- enctype="multipart/form-data" --> 
<input type="hidden" name="emgncyFlag" id="_emgncyFlag" value="N">
<input type="hidden" id="atchFileGrpId" name="atchFileGrpID">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Subject<span class="must">*</span></th>
    <td colspan="3">
    <input id="ntceSubject" name="ntceSubject" type="text" title="" placeholder="Subject" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Writer</th>
    <td colspan="3">
    <input id="rgstUserNm" name="rgstUserNm" value="${userName}"  type="text" title="" placeholder="" class="readonly w100p" readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Emergency</th>
    <td>
    <label><input id="_emgncyFlagCheck" type="checkbox"onclick="javascript:fn_checkbox();" /><span></span></label>
    </td>
    <th scope="row">Password</th>
    <td>
    <input id="password" name="password"  type="password" onkeydown="onlyNumber(this)" title="" placeholder="Number Only" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Notice Period</th>
    <td colspan="3">
    
    <div class="date_set"><!-- date_set start -->
    <p><input id="ntceStartDt" name="ntceStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="ntceEndDt" name="ntceEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Contents<span class="must">*</span></th>
    <td colspan="3">
    <textarea id="ntceCntnt" name="ntceCntnt" cols="20" rows="30" style="margin: 0px 4px 0px 0px; width: 827px; height: 340px;"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2">Attached File</th>
    <td>
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px"/>
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="left_btns">
    <li><p class="red_text">* 표시가 된 곳은 필수 입력입니다.</p></li>
</ul>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_saveNewNotice();">Save</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_close();">Cancel</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_close();">List</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

