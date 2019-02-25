: ${version:=7}
: ${arch:=x86_64}
: ${tempestoptions:=--smoke}
: ${label:=openstack-mkcloud-SLE12-x86_64}

export TESTHEAD=1
export cloudsource=develcloud${version}
export nodenumber=2
export mkcloudtarget=all_batch
export tempestoptions=${tempestoptions}
export label=${label}
export scenario=cloud${version}-2nodes-default.yml
export want_node_aliases=controller=1,compute-kvm=1
export job_name=cloud-mkcloud${version}-job-2nodes-${arch}
