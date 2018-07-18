<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

var currentDate = new Date();
var dd = currentDate.getDate();
var mm = currentDate.getMonth() + 1;
var yyyy = currentDate.getFullYear();

$(document).ready(function(){
	var payModeCombo = "";
	$.ajaxPrefilter(function( options, original_Options, jqXHR ) {
	    options.async = true;
	});

});

function fn_EditMemberValidDate(){
       var ResultM ={
    		   membercode:         $('#membercode').val(),
    		   memberValidDt:      $('#memberValidDt').val()
    }

   var saveForm;

        saveForm ={
              "ResultM": ResultM
      }

      if (validRequiredField()){
          Common.ajax("POST","/organization/memberValidateUpdate.do", saveForm, function(result){
              console.log(result);
              Common.alert("Member Valid Date Save successfully.",fn_close);
          });

      }
}

function fn_close(){
    //$("#popup_wrap").remove();
    location.reload();
}

function validRequiredField()
{
	 var  valid = "true";
	 if($("#memberValidDt").val() == ''){
	        Common.alert("Please Select Valid Date before Save");
	        return false;
	    }
	 return valid;
	}


</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Edit Member Valid Date</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick = "javascript:fn_close();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="memberAddForm" >

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Code</span></th>
    <td colspan="2">
    <input type="text" title="" id="membercode" name="membercode" placeholder="Member Name"  readonly class="w100p"  value="<c:out value="${membercode}"/>"/>
    </td>
    <th scope="row">Member Valid Date</span></th>
    <td>
    <input type="text" title="" id="memberValidDt" name="memberValidDt" placeholder="DD/MM/YYYY"  class="j_date"  value="<c:out value="${memValidDate.membervalidto}"/>"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_EditMemberValidDate();">Save</a></p></li>
</ul>

</form>
</section><!-- search_table end -->


</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<form name="reportForm" id="reportForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="Excel" />
    <input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />
</form>