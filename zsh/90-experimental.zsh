cdb() {
    cd "$(git rev-parse --show-toplevel)"
}

gitcheck() {
    local git_marker
    local repo
    local repo_name
    local -i needs_staging=0
    local -i needs_commit=0
    local -i needs_push=0
    local -i missing_upstream=0
    local -i ahead_count=0
    local -i issues_found=0

    while IFS= read -r git_marker; do
        needs_staging=0
        needs_commit=0
        needs_push=0
        missing_upstream=0
        ahead_count=0

        git_marker=${git_marker%/}
        repo=${git_marker:h}
        repo_name=${repo:t}

        if ! git -C "$repo" diff --quiet --; then
            needs_staging=1
        fi

        if [[ -n "$(git -C "$repo" ls-files --others --exclude-standard)" ]]; then
            needs_staging=1
        fi

        if ! git -C "$repo" diff --cached --quiet --; then
            needs_commit=1
        fi

        if [[ -n "$(git -C "$repo" remote)" ]]; then
            if git -C "$repo" rev-parse --verify --quiet '@{upstream}' >/dev/null 2>&1; then
                ahead_count=$(git -C "$repo" rev-list --count '@{upstream}..HEAD')

                if (( ahead_count > 0 )); then
                    needs_push=1
                fi
            else
                missing_upstream=1
            fi
        fi

        if (( needs_staging || needs_commit || needs_push || missing_upstream )); then
            issues_found=1

            print
            print -r -- "📁 $repo_name"
            git -C "$repo" status --short --branch

            if (( needs_staging )); then
                print -r -- " -> Files need to be staged"
            fi

            if (( needs_commit )); then
                print -r -- " -> Staged changes need to be committed"
            fi
            
            if (( needs_push )); then
                print -r -- " -> $ahead_count commit(s) need to be pushed"
            fi

            if (( missing_upstream )); then
                print -r -- " -> Current branch has a remote but no upstream"
            fi
        fi

        if (( ! issues_found )); then
            print -r -- " ℹ️ All repositories are clean. Great work!"
        fi

    done < <(fd -HI '^\.git$' ~/Projects)
}