<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>
<script src="https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js"></script>
<style>
      .btn-tag {
        background-color: #ECEFF1;
        text-transform: capitalize !important;
        margin-bottom: 10px;
        box-shadow: none;
      }

      .btn-tag:hover {
        box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .25), 0 3px 10px 5px rgba(0, 0, 0, 0.05) !important;
      }

      .grid-item {
        width: 50%
      }

      .grid-item img {
        width: 100%
      }
</style>

<div style="min-height: 100vh; flex-direction:column;" class="d-flex align-items-center mainBackground" id="page1">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Pilih Sebab Gagal</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>

								<div class="form-outline col">
								            <h5>&nbsp;Lokasi Gagal Pemasangan :</h5>
								            <select class="form-control" id="failLoc">
								                    <!--FAIL AT LOCATION-->
								                    <option value="8000" selected>GAGAL DI LOKASI</option>
								                      <!--FAIL BEFORE ARRIVE LOCATION-->
								                    <option value="8100">GAGAL SEBELUM SAMPAI DI LOKASI</option>
								            </select>
								</div>
								<div class="form-outline mt-3 col">
								            <h5>&nbsp;Sebab Gagal :</h5>
								            <select class="form-control" id="failReason"></select>
								</div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackMain" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage2" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Seterusnya</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>

<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page2">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Foto Diperlukan</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>
                               <div id="installUploadContainer"></div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage1" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage3" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Seterusnya</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>


<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page3">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Pengesahan</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                                <div class="row">
                                      <div class="col-6"><h4>Nombor Pemasangan: </h4></div>
                                      <div class="col-6"><h4 class="font-weight-bold">${installationInfo.installEntryNo}</h4></div>
                                </div>
                                <div class="row">
                                          <div class="col-6"><h5>Nombor Pesanan: </h5></div>
                                          <div class="col-6"><h5>${installationInfo.salesOrdNo}</h5></div>
                                 </div>
                                <div class="row">
                                     <div class="col-6"><h5>Tarikh Pesanan: </h5></div>
                                     <div class="col-6"><h5 id="salesDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Tarikh Pemasangan: </h5></div>
                                     <div class="col-6"><h5 id="doDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Lokasi Gagal: </h5></div>
                                     <div class="col-6"><h5 id="location"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Sebab Gagal: </h5></div>
                                     <div class="col-6"><h5 id="reason"></h5></div>
                                </div>
                                <div class="row" style="display:none;" id="failTitle">
                                     <div class="col-6"><h4 class="text-danger">Gagal: </h4></div>
                                </div>
                                <div id="displayUploadContainer"></div>

                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage2" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnSubmit" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Hantar</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>

<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert" hidden />
<div class="modal" id="myModalAlert" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">Maklumat Sistem</h4>
            </div>
            <div class="modal-body" id="MsgAlert" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal"  style="width:100%;background:#4f90d6 !important;">Tutup</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<input type="button" id="alertModalClick2" data-toggle="modal" data-target="#myModalAlert2" hidden />
<div class="modal" id="myModalAlert2" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">Maklumat Sistem</h4>
            </div>
            <div class="modal-body" id="MsgAlert2" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="reload()" style="width:100%;background:#4f90d6 !important;">Tutup</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javaScript">

     const reload = () => {window.location = "https://www.google.com";}

	$("#salesDt").text($("#salesDt").text() + moment("${installationInfo.salesDt}").format("DD-MM-YYYY"));
	$("#doDt").text($("#doDt").text() + moment("${installationInfo.installDt}").format("DD-MM-YYYY"));


	$(function(){
	    let x = document.querySelector('.bottom_msg_box');
	     x.style.display = "none";
	});

	const openPage1 = () => {
		document.querySelector("#page2").classList.remove("d-flex");
		document.querySelector("#page2").style.display = "none";

	    document.querySelector("#page3").classList.remove("d-flex");
	    document.querySelector("#page3").style.display = "none";

		document.querySelector("#page1").classList.add("d-flex");
        document.querySelector("#page1").style.display = "";
	}

	const openPage2 = () => {
        document.querySelector("#page1").classList.remove("d-flex");
        document.querySelector("#page1").style.display = "none";

        document.querySelector("#page3").classList.remove("d-flex");
        document.querySelector("#page3").style.display = "none";

        document.querySelector("#page2").classList.add("d-flex");
        document.querySelector("#page2").style.display = "";
    }

	const openPage3 = () => {
        document.querySelector("#page1").classList.remove("d-flex");
        document.querySelector("#page1").style.display = "none";

        document.querySelector("#page2").classList.remove("d-flex");
        document.querySelector("#page2").style.display = "none";

        document.querySelector("#page3").classList.add("d-flex");
        document.querySelector("#page3").style.display = "";

        displayImageUpload(document.getElementById("displayUploadContainer"));
        const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
        let flag = false;
        for(let i = 0; i < installUploadContainer.length; i++){
            if(installUploadContainer[i].files[0]){
                   flag=true;
            }
        }
        if(flag){
        	const failTitle =document.getElementById("failTitle");
        	failTitle.style.display="";
        }
    }

	const displayImageUpload = (el) => {
        let uploadImg = document.querySelectorAll('img.install');
        let resetImg = document.getElementById('displayUploadContainer');

        resetImg.innerHTML = "";

        const grid = document.createElement("div");
        grid.classList.add("grid");


        for(let i=0; i < uploadImg.length; i++){
            const gridItem = document.createElement("div");
            gridItem.classList.add("grid-item");
            gridItem.classList.add("card");

            const cardBody = document.createElement("div");
            cardBody.classList.add("card-body");

	        const displayImg = document.createElement("img");
	         displayImg.classList.add("display");

	         if(uploadImg[i].src){
	        	  displayImg.src = uploadImg[i].src;
	        	  cardBody.appendChild(displayImg);
	              gridItem.appendChild(cardBody);
	              grid.appendChild(gridItem);
	         }
        }

        el.appendChild(grid);

        $('.grid').masonry({
          itemSelector: '.grid-item'
        });
	}


    const addImageUpload = (el, titleName) => {
        //image upload
        const title = document.createElement("h5");
        title.innerHTML = "&nbsp;" + titleName + " : ";

        const photoDiv = document.createElement("div");

        const aElement = document.createElement("a");
        aElement.classList.add("btn");
        aElement.classList.add("btn-tag");
        aElement.classList.add("btn-rounded");
        aElement.classList.add("m-2");
        aElement.innerText = "Photo";

        const image = document.createElement("img");
        image.style.width = "100%";
        image.classList.add("install");

        const upload = document.createElement("input");
        upload.type = "file";
        upload.style.display="none";
        upload.accept = ".jpeg,.png,.jpg";

        upload.onchange = (e) => {
        	if(e.target.files[0].type !="image/jpeg" && e.target.files[0].type !="image/png"){
        		document.getElementById("MsgAlert").innerHTML =  "Hanya boleh memuat naik fail imej png dan jpeg";
                $("#alertModalClick").click();
        	}
        	else if(e.target.files[0].size > 2048000){
                document.getElementById("MsgAlert").innerHTML =  "Tidak boleh memuat naik fail imej melebihi 2MB.";
                $("#alertModalClick").click();
        	}
        	else{
                image.src = URL.createObjectURL(e.target.files[0]);
        	}
        }

        el.appendChild(title);
        el.appendChild(photoDiv);
        photoDiv.appendChild(aElement);
        el.appendChild(upload);
        el.appendChild(image);

        aElement.onclick = () => {
            upload.click();
        }

        //camera
        const openCamera = document.createElement("button");
        const screenshot = document.createElement("button");
        const aElement2 = document.createElement("a");
        aElement2.classList.add("btn");
        aElement2.classList.add("btn-tag");
        aElement2.classList.add("btn-rounded");
        aElement2.classList.add("m-2");
        aElement2.innerText = "Kamera";

        const aElement3 = document.createElement("a");
        aElement3.classList.add("btn");
        aElement3.classList.add("btn-tag");
        aElement3.classList.add("btn-rounded");
        aElement3.classList.add("m-2");
        aElement3.innerText = "Tangkap";

        openCamera.style.display = "none";
        screenshot.style.display = "none";
        aElement3.style.display = "none";

        el.insertBefore(openCamera, image);
        el.insertBefore(screenshot, image);
        photoDiv.appendChild(aElement2);
        photoDiv.appendChild(aElement3);

        aElement2.onclick = (e) => {
        	e.preventDefault()
            navigator.mediaDevices.getUserMedia({video: {facingMode: 'environment'}})
            .then(s => {
            	aElement.style.display = "none";
            	aElement2.style.display = "none";
            	aElement3.style.display = "";
                image.style.display = "none";
                const video = document.createElement("video");
                video.style.width = "100%";
                const c = document.createElement("canvas");
                c.style.display = "none";
                el.appendChild(c);
                video.srcObject = s;
                el.insertBefore(video, image);
                video.play();
                aElement3.onclick = () => {
                	aElement3.style.display = "none";
                	aElement.style.display = "";
                    aElement2.style.display = "";
                    c.height = video.videoHeight;
                    c.width = video.videoWidth;
                    const ctx = c.getContext('2d');
                    ctx.drawImage(video, 0, 0, c.width, c.height);
                    image.src = c.toDataURL();
                    c.toBlob(b => {
                        const f = new File([b], 'upload.jpg');
                        const container = new DataTransfer();
                        container.items.add(f);
                        upload.files = container.files;
                        s.getTracks().forEach(t => t.stop());
                        image.style.display = "";
                        video.remove();
                        c.remove();
                    }, 'image/jpeg')
                }
            })
        }

    }

    for (let i = 0; i < 4; i++) {
    	let titleName = "Attachment "+ (i+1);
        addImageUpload(document.getElementById("installUploadContainer") , titleName)
    }

    const failLoc = document.getElementById("failLoc")
    const failReason = document.getElementById("failReason")
    getErrorCode = () => {
    	fetch("/homecare/services/install/selectFailChild.do?groupCode=" + document.querySelector("#failLoc option:checked").value)
    	.then(r => r.json())
    	.then(d => {
    		failReason.innerHTML = ""
    		for(let i = 0; i < d.length; i++) {
    			const {codeName, codeId} = d[i]
    			failReason.innerHTML += "<option value=" + codeId + ">" + codeName + "</option>"
    		}
    	})
    }
    getErrorCode()
    failLoc.onchange = getErrorCode

    $("#btnBackMain").click(e => {
        e.preventDefault()
	    window.top.Common.showLoader();
	    window.top.location.href = '/homecare/services/install/getAcInstallationInfo.do?insNo=${insNo}';
    })

    $("#btnBackPage1").click(e => {
        e.preventDefault()
        openPage1();
    })

     $("#btnBackPage2").click(e => {
        e.preventDefault()
        openPage2();
    })

    $("#btnNextPage2").click(e => {
        e.preventDefault()
        openPage2();
    })

    $("#btnNextPage3").click(e => {
        e.preventDefault()
        $("#location").text($("#failLoc option:selected").text());
        $("#reason").text($("#failReason option:selected").text());
        openPage3();
    })


    let attachment = 0;
    const insertPreInsFail = () => {
    	const insNo = "${insNo}", failLoc = document.querySelector("#failLoc").value, failReason = $("#failReason").val();
        fetch("/homecare/services/install/insertPreInsFail.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                  insNo,
                  failLoc,
                  failReason,
                  attachment
            })
        })
        .then(() => {
        	document.getElementById("MsgAlert2").innerHTML =  "Pemasangan telah lengkap. Sila tutup paparan ini.";
            $("#alertModalClick2").click();
        })
        .catch(() => {
        	document.getElementById("MsgAlert2").innerHTML =  "Pemasangan gagal untuk dihantar.";
        	$("#alertModalClick2").click();
        })
    }

    $("#btnSubmit").click(e => {
    	e.preventDefault();
        fetch("/homecare/services/install/selectInstallationInfo.do?insNo=${insNo}")
        .then(r => r.json())
        .then(resp => {
            if(!resp.dupCheck){
            	   const formData = new FormData();
                   const container = new DataTransfer();
                   const installUploadContainer = document.querySelectorAll("#installUploadContainer input");

                   let uploadFlag = false;

                   for(let i = 0; i < installUploadContainer.length; i++){
                       if(installUploadContainer[i].files[0]){
                           uploadFlag=true;
                           container.items.add(new File([installUploadContainer[i].files[0]], 'MOBILE_SVC_${insNo}_' + moment().format("YYYYMMDD")  + '_' + (i+1) +'.png', {type: installUploadContainer[i].files[0].type}))
                       }
                   }

                   if(uploadFlag){
                       $.each(container.files, function(n, v) {
                           formData.append(n, v);
                       });

                       fetch("/homecare/services/install/uploadInsImage.do", {
                           method: "POST",
                           body: formData
                       })
                       .then(d=>d.json())
                       .then(r=> {
                           attachment = r.fileGroupKey;
                           insertPreInsFail();
                       });
                   }else{
                       insertPreInsFail();
                   }
            }
            else{
                   document.getElementById("MsgAlert").innerHTML =  "Pesanan ini tidak dibenarkan untuk diserahkan lagi";
                 $("#alertModalClick").click();
            }
        });
    })

</script>