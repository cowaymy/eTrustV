<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
console.log("memberSocialMediaPop");

var myFileCaches = {};

var update = new Array();
var remove = new Array();
var photo1ID = 0;
var photo1Name = "";
var fileGroupKey ="";


$(document).ready(function() {
    fn_getMemInfo();
});

$("#photo1Txt").dblclick(function(){
	var data = {
            memId : '${MemberID}'
    };
   Common.ajax("GET", "/organization/getAttachmentInfo.do", data, function(result) {
       var fileSubPath = result.fileSubPath;
       fileSubPath = fileSubPath.replace('\', '/'');
       window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
   });
});

function fn_getMemInfo(){
    Common.ajax("GET", "/organization/selectSocialMedia.do?_cacheId=" + Math.random(), $("#memberAddForm").serialize(), function(result) {
        if(result != null ){
            fn_setMemInfo(result);
        }else{
            console.log("========result null=========");
        }
    });
}

function fn_setMemInfo(data){
       $("#memberCode").val(data.memCode);
       $("#fbLink").val(data.fbLink);
       $("#igLink").val(data.igLink);
       var fileSubPath = data.fileSubPath;
       if(fileSubPath != null){
    	    fileSubPath = fileSubPath.replace('\', '/'');
    	    $("#photo1Txt").val(fileSubPath + "/" +  data.physiclFileName);
       }
}

function fn_saveConfirm(){

   if (fn_validate()){
	   Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_memberSave);
   }

}

function fn_validate(){
	var msg = "";

    if ($("#fbLink").val() == '') {
        msg += "* Please fill in FB Link </br>";
    }

    if ($("#igLink").val() == '') {
        msg += "* Please fill in IG Link </br>";
    }

    var input = document.getElementById('photo1');
    if (input.files.length > 0) {
    	for (var i = 0; i <= input.files.length - 1; i++) {

            var fsize = input.files.item(i).size;

            if (!input.files.item(i)) {
                msg += "* Please choose HP Photo </br>";
           }

            if (fsize > 10000000){
                msg += "* Only allows Max file size : 10MB </br>";
            }
        }
    }

    var FileExt = $("#photo1Txt").val().split('.').pop().toUpperCase();

    if( FileExt != 'JPG' && FileExt != 'PNG' && FileExt != 'JPEG')
    {
    	msg += "* Only allow picture format (JPG, PNG, JPEG) </br>";
    }
    if (msg != "") {
        Common.alert(msg);
        return false;
    }

    return true;
}


function fn_memberSave(){

	 var formData = Common.getFormData("memberAddForm");
	 var obj = $("#memberAddForm").serializeJSON();
	 $.each(obj, function(key, value) {
         formData.append(key, value);
       });

	 Common.ajaxFile("/organization/updateSocialMedia.do", formData, function(result) {
         Common.alert(result.message, fn_close);
         fn_memberListSearch()
     });
}

function fn_close(){
    $("#popup_wrap").remove();
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Social Media Information</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" id="memberUpdForm" method="post"></form>

        <form action="#" id="memberAddForm" method="post">
            <input type="hidden" id="memType" name="memType" value="${memType}">
            <input type="hidden"id="MemberID" name="MemberID" value="${MemberID}">
            <input type="hidden" value="<c:out value="${socialMedia.memCode}"/> "  id="memCode" name="memCode"/>
			<input type="hidden" value="<c:out value="${socialMedia.fileSubPath}"/> "  id="fileSubPath" name="fileSubPath"/>
			<input type="hidden" value="<c:out value="${socialMedia.physiclFileName}"/> "  id="physiclFileName" name="physiclFileName"/>

            <section class="tap_wrap"><!-- tap_wrap start -->

                <!-- Basic Info -->
                <article class="tap_area">
                <!-- tap_area start -->
                    <!-- table start -->
                    <table class="type1">
                        <caption>table</caption>
						<colgroup>
						    <col style="width:190px" />
						    <col style="width:*" />
						    <col style="width:150px" />
						    <col style="width:*" />
						</colgroup>
                        <tbody>
                            <tr id="editRow1_1">
                                <th scope="row">Code</th>
                                <td colspan=6>
                                    <input type="text" title="" id="memberCode" placeHolder="Member Code" class="w100p" disabled value="<c:out value="${socialMedia.memCode}"/>"/>
                                </td>
                            </tr>
                            <br/>
                            <tr id="editRow1_2">
                            <th scope="row">FB Link</th>
                                <td colspan=6>
                                   <input type="text" title="" id="fbLink" name="fbLink" placeholder="FB Link" class="w100p"  value="<c:out value="${socialMedia.fbLink}"/>"/>
                                </td>
                            </tr>
                            <tr>
                            <th scope="row">IG Link<span class="must">*</span></th>
                                <td colspan=6>
                                   <input type="text" title="" id="igLink" name="igLink" placeholder="IG Link" class="w100p"  value="<c:out value="${socialMedia.igLink}"/>"/>
                                </td>
                            </tr>
						     <tr>
				            <th scope="row">Attach Picture</th>
				            <td>
				                <div class="auto_file2 auto_file3">
				                    <input type="file" title="file add" id="photo1" accept="image/*"/>
				                        <label>
				                            <input type='text' class='input_text' readonly='readonly' id='photo1Txt'/>
				                            <span class='label_text'><a href='#'>Upload</a></span>
				                        </label>
				                </div>
				            </td>
				            </tr>
				            <tr>
				                <td colspan=7><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
				            </tr>
                        </tbody>
                    </table><!-- table end -->
                </article>
                <!-- tap_area end -->
        </form>

            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
            </ul>
        </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->

</div><!-- popup_wrap end -->
