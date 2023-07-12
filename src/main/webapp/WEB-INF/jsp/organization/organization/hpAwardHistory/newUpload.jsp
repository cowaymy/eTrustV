<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
    .auto_file4{position:relative; width:237px; padding-right:62px; height:20px;}
    .auto_file4{float:none!important; width:490px; padding-right:0; margin-top:5px;}
    .auto_file4:first-child{margin-top:0;}
    .auto_file4:after{content:""; display:block; clear:both;}
    .auto_file4.w100p{width:100%!important; box-sizing:border-box;}
    .auto_file4 input[type=file]{display:block; overflow:hidden; position:absolute; top:-1000em; left:0;}
    .auto_file4 label{display:block; margin:0!important;}
    .auto_file4 label:after{content:""; display:block; clear:both;}
    .auto_file4 label{float:left; width:300px;}
    .auto_file4 label input[type=text]{width:100%!important;}
    .auto_file4 label input[type=text]{width:237px!important; float:left}
    .auto_file4.attachment_file label{float:left; width:407px;}
    .auto_file4.attachment_file label input[type=text]{width:345px!important; float:left}
    .auto_file4 span.label_text2{float:left;}
    .auto_file4 span.label_text2 a{display:block; height:20px; line-height:20px; margin-left:5px; min-width:47px; text-align:center; padding:0 5px; background:#a1c4d7; color:#fff; font-size:11px; font-weight:bold; border-radius:3px;}
</style>

<div class="popup_wrap">
    <header class="pop_header">
        <h1>Award History - File Upload</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <p style="color: #25527c; padding-left: 5px;">Loyalty HP File Upload</p><br/>
        <form method="post">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">File</th>
                        <td colspan=3>
                            <div id="hpAwardFileInput" class="auto_file4" style="width: auto;">
                              <input type="file" title="file add" accept=".csv" />
                              <label for="hpAwardFileInput">
                                  <input id="hpAwardFile" type="text" class="input_text" readonly class="readonly">
                                  <span class="label_text2"><a href="#">File</a></span>
                              </label>
                          </div>
                        </td>
                    </tr>
                    <tr>
                        <th colspan=5><span class="must">* Only accept CSV format. Max file size only 2MB.</span></th>
                    </tr>
                </tbody>
            </table>
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a id="btnUploadFile">Upload File</a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/organization/hpAwardHistoryUploadFormat.csv">Download Template</a></p></li>
        </ul>
 </section>
</div>

<script>

	document.querySelectorAll(".auto_file4 label").forEach(label => {
	    label.onclick = () => {
	        label.parentElement.querySelector("input[type=file]").click()
	    }
	});

	const validation = () =>{
	      if (document.getElementById("hpAwardFile").parentElement.parentElement.querySelector("input[type=file]").files.length == 0) {
	            Common.alert("Kindly upload HP Award History File.")
	            return false;
	      }

          if (document.getElementById("hpAwardFile").parentElement.parentElement.querySelector("input[type=file]").files[0].type !="text/csv") {
              Common.alert("Kindly upload HP Award History File with CSV format only.")
              return false;
          }

          if (document.getElementById("hpAwardFile").parentElement.parentElement.querySelector("input[type=file]").files[0].size > 2000000) {
              Common.alert("The file size of HP Award History File cannot upload over 2MB.")
              return false;
          }

	      return true;
	}

	$("#btnUploadFile").click((e)=>{
		e.preventDefault();
		if(validation()){
			Common.showLoader();
			const formData = new FormData();
			formData.append("newUpload", document.getElementById("hpAwardFile").parentElement.parentElement.querySelector("input[type=file]").files[0]);
			console.log(formData);
			fetch("/organization/submitHpAwardHistory.do",{
				method: "POST",
				body: formData
			})
			.then((r)=> r.json())
			.then((data) =>{
			       Common.removeLoader();
				   Common.alert(data.msg , data.success==1 ? ()=>{location.reload()} : '');
			});
		}
	});

</script>