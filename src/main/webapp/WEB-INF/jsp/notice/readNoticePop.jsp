<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<html>
<script type="text/javascript">

	$(document).ready(function() {
	    fn_selectNoticeListAjax(); 
	});
	
    function fn_close() {
        $("#popClose").click();
        fn_selectNoticeListAjax(); 
	}
	
    
    function onlyNumber(obj) {
        $(obj).keyup(function(){
             $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    }
    
    function fn_modifyNotice() {
    	
        if($("#ntceSubject").val() == ''){
            Common.alert("Please key in Subject");
            return false;
        }
        if($("#ntceCntnt").val() == ''){
            Common.alert("Please key in Content");
            return false;
        }
        
        Common.ajax("POST", "/notice/updateNotice.do", $("#noticeForm").serializeJSON(), function(result){
            
/*             if(result == null){
                Common.alert("result is null");
            }else{
                console.log("result : " + result);
                console.log("result(type) : " + $.type(result));
                console.log("result.msg : " + result.msg);
            } */
                Common.alert(result.message);
                $("#popClose").click();
                fn_selectNoticeListAjax(); 
        });
    };
    
    //Check Box
    var emgncyFlag = $("#_emgncyFlag").val() == 'Y' ? true : false;
    
    if(emgncyFlag == true){
    	 $("#_emgncyFlag").attr("checked", true);
    }


</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View Notice</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="noticeForm" name="noticeForm">
<input type="hidden" id="ntceNo" name="ntceNo" value="${noticeInfo.ntceNo}">
<input type="hidden" id="crtUserId" name="crtUserId" value="${noticeInfo.crtUserId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Subject<span class="must">*</span></th>
    <td colspan="5">
    <input id="ntceSubject" name="ntceSubject" value="${noticeInfo.ntceSubject}" type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Writer</th>
    <td>
    <input id="rgstUserNm" value="${noticeInfo.rgstUserNm}" type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" />
    </td>
    <th scope="row">Issue Date</th>
    <td>
    <input id="crtDt" name="crtDt" value="${fn:substring(noticeInfo.crtDt,0,10)}" type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" />
    </td>
    <th scope="row">Read Count</th>
    <td>
    <input id="readCnt" name="readCnt"  value="${noticeInfo.readCnt}" type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" />
    </td>
</tr>
<tr>
    <th scope="row">Emergency</th>
    <td>
    <label><input id="_emgncyFlag" name="emgncyFlag" value="${noticeInfo.emgncyFlag}" type="checkbox" /><span></span></label>
    </td>
    <th scope="row">Password</th>
    <td colspan="3">
    <input id="password" name="password" value="${noticeInfo.password}" type="password" title="" placeholder="" class="" />
    </td>
</tr>
<tr>
    <th scope="row">Notice Period</th>
    <td colspan="5">
    
    <div class="date_set"><!-- date_set start -->
    <p><input id="ntceStartDt" name="ntceStartDt" value="${noticeInfo.ntceStartDt}" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="ntceEndDt" name="ntceEndDt" value="${noticeInfo.ntceEndDt}" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Contents<span class="must">*</span></th>
    <td colspan="5">
    <textarea id="ntceCntnt" name="ntceCntnt" cols="20" rows="30" style="margin: 0px 4px 0px 0px; width: 827px; height: 340px;">${noticeInfo.ntceCntnt}</textarea>
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
    <div class="auto_file2"><!-- auto_file start -->
    <input id="atchFileGrpId"  name="atchFileGrpId" value="${noticeInfo.atchFileGrpId}" type="file" title="file add" />
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="left_btns">
    <li><p class="red_text">* 표시가 된 곳은 필수 입력입니다.</p></li>
</ul>

<c:choose>
    <c:when test="${not empty noticeInfo.crtUserId && noticeInfo.rgstUserNm eq userName}">
     <ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_modifyNotice();">Modify</a></p></li>
	    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_deleteNotice();">Delete</a></p></li>
	    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_close();">List</a></p></li>
    </ul>
    </c:when>
    <c:otherwise>
      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_close();">List</a></p></li>
      </ul>
    </c:otherwise>
</c:choose>



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>